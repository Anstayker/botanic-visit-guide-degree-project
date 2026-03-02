import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/entities/user_position.dart';
import '../../../../core/usecases/stream_usecase.dart';
import '../../domain/entities/exploration_plant.dart';
import '../../domain/usecases/exploration_unlock_plant.dart';
import '../../domain/usecases/exploration_watch_nearby_plants.dart';

part 'exploration_event.dart';
part 'exploration_state.dart';

class ExplorationBloc extends Bloc<ExplorationEvent, ExplorationState> {
  final ExplorationWatchNearbyPlants watchNearbyPlants;
  final ExplorationUnlockPlant unlockPlant;
  StreamSubscription? _plantSubscription;

  ExplorationBloc({required this.watchNearbyPlants, required this.unlockPlant})
    : super(
        const ExplorationState(
          status: ExplorationStatus.initial,
          plants: [],
          isSonarActive: false,
        ),
      ) {
    on<ExplorationWatchStarted>(_onStarted);
    on<_NearbyPlantsFailed>(_onNearbyPlantsFailed);
    on<_NearbyPlantsUpdated>(_onNearbyPlantsUpdated);
    on<ExplorationSonnarTriggered>(_onSonarButtonPressed);
    on<ExplorationPlantUnlockRequested>(_onPlantUnlockRequested);
  }

  Future<void> _onStarted(
    ExplorationWatchStarted event,
    Emitter<ExplorationState> emit,
  ) async {
    emit(state.copyWith(status: ExplorationStatus.loading));

    await _plantSubscription?.cancel();

    _plantSubscription = watchNearbyPlants(NoParams()).listen((result) {
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

  Future<void> _onPlantUnlockRequested(
    ExplorationPlantUnlockRequested event,
    Emitter<ExplorationState> emit,
  ) async {}

  @override
  Future<void> close() {
    _plantSubscription?.cancel();
    return super.close();
  }
}
