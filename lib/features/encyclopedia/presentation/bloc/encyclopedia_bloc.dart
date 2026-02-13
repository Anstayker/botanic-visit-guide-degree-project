import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/entities/plant.dart';
import '../../domain/entities/plant_filter_params.dart';
import '../../domain/usecases/ency_watch_all_plants.dart';

part 'encyclopedia_event.dart';
part 'encyclopedia_state.dart';

class EncyclopediaBloc extends Bloc<EncyclopediaEvent, EncyclopediaState> {
  final EncyWatchAllPlants watchAllPlants;
  StreamSubscription? _plantsSubscription;
  int _currentRequestId = 0;

  EncyclopediaBloc({required this.watchAllPlants})
    : super(EncyclopediaInitial()) {
    on<WatchPlantsRequested>(_onWatchPlantsRequested);
    on<WatchPlantsStopped>(_onWatchPlantsStopped);
    on<_PlantsUpdated>(_onPlantsUpdated);
    on<_PlantsFailed>(_onPlantsFailed);
  }

  Future<void> _onWatchPlantsRequested(
    WatchPlantsRequested event,
    Emitter<EncyclopediaState> emit,
  ) async {
    emit(EncyclopediaLoading());

    // Incrementar el ID de la solicitud actual para invalidar la anterior
    final requestId = ++_currentRequestId;

    // Cancelar la suscripción anterior sin bloquear
    _plantsSubscription?.cancel();

    try {
      final stream = watchAllPlants(Params(filterParams: event.filterParams));

      _plantsSubscription = stream.listen(
        (result) {
          // Solo procesar si esta suscripción sigue siendo la actual
          if (requestId != _currentRequestId) {
            return;
          }

          result.fold(
            (failure) {
              add(_PlantsFailed(failure.message));
            },
            (plants) {
              add(_PlantsUpdated(plants));
            },
          );
        },
        onError: (error, stackTrace) {
          if (requestId == _currentRequestId) {
            add(_PlantsFailed(error.toString()));
          }
        },
      );
    } catch (e) {
      emit(EncyclopediaError(message: 'Error: $e'));
    }
  }

  Future<void> _onWatchPlantsStopped(
    WatchPlantsStopped event,
    Emitter<EncyclopediaState> emit,
  ) async {
    // Cancelar sin bloquear
    _plantsSubscription?.cancel();
    _plantsSubscription = null;
    _currentRequestId++;
    emit(EncyclopediaInitial());
  }

  void _onPlantsUpdated(_PlantsUpdated event, Emitter<EncyclopediaState> emit) {
    emit(EncyclopediaLoaded(plants: event.plants));
  }

  void _onPlantsFailed(_PlantsFailed event, Emitter<EncyclopediaState> emit) {
    emit(EncyclopediaError(message: event.message));
  }

  @override
  Future<void> close() async {
    // Cancelar sin bloquear e incrementar el ID para invalidad cualquier evento pendiente
    _plantsSubscription?.cancel();
    _currentRequestId++;
    return super.close();
  }
}
