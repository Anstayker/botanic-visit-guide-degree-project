part of 'exploration_bloc.dart';

sealed class ExplorationEvent extends Equatable {
  const ExplorationEvent();

  @override
  List<Object> get props => [];
}

class ExplorationWatchStarted extends ExplorationEvent {}

class _NearbyPlantsUpdated extends ExplorationEvent {
  final List<ExplorationPlant> nearbyPlants;

  const _NearbyPlantsUpdated(this.nearbyPlants);

  @override
  List<Object> get props => [nearbyPlants];
}

class _NearbyPlantsFailed extends ExplorationEvent {
  final String message;

  const _NearbyPlantsFailed(this.message);

  @override
  List<Object> get props => [message];
}

class ExplorationSonnarTriggered extends ExplorationEvent {}

class ExplorationPlantUnlockRequested extends ExplorationEvent {
  final String plantId;

  const ExplorationPlantUnlockRequested({required this.plantId});

  @override
  List<Object> get props => [plantId];
}
