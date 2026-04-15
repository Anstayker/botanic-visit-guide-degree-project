import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/entities/user_position.dart';
import '../../../../core/usecases/stream_usecase.dart' as stream_usecase;
import '../../../../core/usecases/usecase.dart' as core_usecase;
import '../../../plant_progress/domain/usecases/discover_plant.dart'
    as plant_progress;
import '../../domain/entities/exploration_plant.dart';
import '../../domain/entities/exploration_map_region.dart';
import '../../domain/usecases/exploration_watch_nearby_plants.dart';
import '../../domain/usecases/get_map_tile_cache_max_size_bytes.dart';
import '../../domain/usecases/get_exploration_map_regions.dart';
import '../../domain/usecases/get_radar_rotation_enabled.dart';
import '../../domain/usecases/set_radar_rotation_enabled.dart';
import '../../../../core/services/location/location_service.dart';

part 'exploration_event.dart';
part 'exploration_state.dart';

class ExplorationBloc extends Bloc<ExplorationEvent, ExplorationState> {
  final ExplorationWatchNearbyPlants watchNearbyPlants;
  final plant_progress.DiscoverPlant discoverPlant;
  final GetExplorationMapRegions getExplorationMapRegions;
  final GetMapTileCacheMaxSizeBytes getMapTileCacheMaxSizeBytes;
  final GetRadarRotationEnabled getRadarRotationEnabled;
  final SetRadarRotationEnabled setRadarRotationEnabled;
  final LocationService locationService;
  StreamSubscription? _plantSubscription;
  StreamSubscription? _positionSubscription;

  ExplorationBloc({
    required this.watchNearbyPlants,
    required this.discoverPlant,
    required this.getExplorationMapRegions,
    required this.getMapTileCacheMaxSizeBytes,
    required this.getRadarRotationEnabled,
    required this.setRadarRotationEnabled,
    required this.locationService,
  }) : super(
         const ExplorationState(
           status: ExplorationStatus.initial,
           plants: [],
           isSonarActive: false,
           isHeadingRotationEnabled: false,
           mapTileCacheMaxSizeBytes: 80 * 1024 * 1024,
         ),
       ) {
    on<ExplorationWatchStarted>(_onStarted);
    on<_UserPositionUpdated>(_onUserPositionUpdated);
    on<_NearbyPlantsFailed>(_onNearbyPlantsFailed);
    on<_NearbyPlantsUpdated>(_onNearbyPlantsUpdated);
    on<_MapRegionsLoaded>(_onMapRegionsLoaded);
    on<_MapRegionsFailed>(_onMapRegionsFailed);
    on<_RotationPreferenceLoaded>(_onRotationPreferenceLoaded);
    on<_RotationPreferenceFailed>(_onRotationPreferenceFailed);
    on<_MapTileCacheSizeLoaded>(_onMapTileCacheSizeLoaded);
    on<_MapTileCacheSizeFailed>(_onMapTileCacheSizeFailed);
    on<ExplorationSonnarTriggered>(_onSonarButtonPressed);
    on<ExplorationRotationPreferenceToggled>(_onRotationPreferenceToggled);
    on<ExplorationPlantUnlockRequested>(_onPlantUnlockRequested);
  }

  Future<void> _onStarted(
    ExplorationWatchStarted event,
    Emitter<ExplorationState> emit,
  ) async {
    emit(state.copyWith(status: ExplorationStatus.loading));

    final mapRegionsResult = await getExplorationMapRegions(
      core_usecase.NoParams(),
    );
    mapRegionsResult.fold(
      (failure) => add(_MapRegionsFailed(failure.message)),
      (mapRegions) => add(_MapRegionsLoaded(mapRegions)),
    );

    final rotationEnabledResult = await getRadarRotationEnabled(
      core_usecase.NoParams(),
    );
    rotationEnabledResult.fold(
      (failure) => add(_RotationPreferenceFailed(failure.message)),
      (enabled) => add(_RotationPreferenceLoaded(enabled)),
    );
    final mapTileCacheSizeResult = await getMapTileCacheMaxSizeBytes(
      core_usecase.NoParams(),
    );
    mapTileCacheSizeResult.fold(
      (failure) => add(_MapTileCacheSizeFailed(failure.message)),
      (bytes) => add(_MapTileCacheSizeLoaded(bytes)),
    );

    await _plantSubscription?.cancel();
    await _positionSubscription?.cancel();

    _positionSubscription = locationService.watchUserPosition().listen((
      result,
    ) {
      result.fold(
        (failure) {
          add(_NearbyPlantsFailed(failure.message));
        },
        (userPosition) {
          add(_UserPositionUpdated(userPosition));
        },
      );
    });

    _plantSubscription = watchNearbyPlants(stream_usecase.NoParams()).listen((
      result,
    ) {
      result.fold(
        (failure) {
          add(_NearbyPlantsFailed(failure.message));
        },
        (nearbyPlants) {
          add(_NearbyPlantsUpdated(nearbyPlants));
        },
      );
    });
  }

  void _onNearbyPlantsFailed(
    _NearbyPlantsFailed event,
    Emitter<ExplorationState> emit,
  ) {
    emit(
      state.copyWith(
        status: ExplorationStatus.error,
        errorMessage: event.message,
      ),
    );
  }

  void _onUserPositionUpdated(
    _UserPositionUpdated event,
    Emitter<ExplorationState> emit,
  ) {
    emit(state.copyWith(userPosition: event.userPosition));
  }

  void _onMapRegionsLoaded(
    _MapRegionsLoaded event,
    Emitter<ExplorationState> emit,
  ) {
    emit(state.copyWith(mapRegions: event.mapRegions, errorMessage: null));
  }

  void _onMapRegionsFailed(
    _MapRegionsFailed event,
    Emitter<ExplorationState> emit,
  ) {
    emit(state.copyWith(errorMessage: event.message));
  }

  void _onRotationPreferenceLoaded(
    _RotationPreferenceLoaded event,
    Emitter<ExplorationState> emit,
  ) {
    emit(state.copyWith(isHeadingRotationEnabled: event.enabled));
  }

  void _onRotationPreferenceFailed(
    _RotationPreferenceFailed event,
    Emitter<ExplorationState> emit,
  ) {
    emit(state.copyWith(isHeadingRotationEnabled: false));
  }

  void _onMapTileCacheSizeLoaded(
    _MapTileCacheSizeLoaded event,
    Emitter<ExplorationState> emit,
  ) {
    emit(state.copyWith(mapTileCacheMaxSizeBytes: event.bytes));
  }

  void _onMapTileCacheSizeFailed(
    _MapTileCacheSizeFailed event,
    Emitter<ExplorationState> emit,
  ) {
    emit(state.copyWith(errorMessage: event.message));
  }

  void _onNearbyPlantsUpdated(
    _NearbyPlantsUpdated event,
    Emitter<ExplorationState> emit,
  ) {
    ExplorationPlant? detectedPlant;
    for (final plant in event.nearbyPlants) {
      if (plant.isVisibleInRadar && !plant.plant.isDiscovered) {
        detectedPlant = plant;
        break;
      }
    }

    final previousDetectedId = state.nearbyPlantDetected?.plant.id;
    final currentDetectedId = detectedPlant?.plant.id;
    final shouldUpdateDetectedPlant = previousDetectedId != currentDetectedId;

    emit(
      state.copyWith(
        status: ExplorationStatus.success,
        plants: event.nearbyPlants,
        nearbyPlantDetected: shouldUpdateDetectedPlant
            ? detectedPlant
            : state.nearbyPlantDetected,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onSonarButtonPressed(
    ExplorationSonnarTriggered event,
    Emitter<ExplorationState> emit,
  ) async {
    if (state.isSonarActive) return;

    emit(state.copyWith(isSonarActive: true));

    await Future.delayed(const Duration(seconds: 5));

    if (!isClosed) {
      emit(state.copyWith(isSonarActive: false));
    }
  }

  Future<void> _onRotationPreferenceToggled(
    ExplorationRotationPreferenceToggled event,
    Emitter<ExplorationState> emit,
  ) async {
    final result = await setRadarRotationEnabled(
      Params(enabled: event.enabled),
    );

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (enabled) => emit(state.copyWith(isHeadingRotationEnabled: enabled)),
    );
  }

  Future<void> _onPlantUnlockRequested(
    ExplorationPlantUnlockRequested event,
    Emitter<ExplorationState> emit,
  ) async {
    final result = await discoverPlant(
      plant_progress.Params(plantId: event.plantId),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ExplorationStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(errorMessage: null)),
    );
  }

  @override
  Future<void> close() {
    _plantSubscription?.cancel();
    _positionSubscription?.cancel();
    return super.close();
  }
}
