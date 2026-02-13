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
    await _plantsSubscription?.cancel();

    _plantsSubscription =
        watchAllPlants(Params(filterParams: event.filterParams)).listen((
          result,
        ) {
          result.fold(
            (failure) => add(_PlantsFailed(failure.message)),
            (plants) => add(_PlantsUpdated(plants)),
          );
        });
  }

  Future<void> _onWatchPlantsStopped(
    WatchPlantsStopped event,
    Emitter<EncyclopediaState> emit,
  ) async {
    await _plantsSubscription?.cancel();
    _plantsSubscription = null;
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
    await _plantsSubscription?.cancel();
    return super.close();
  }
}
