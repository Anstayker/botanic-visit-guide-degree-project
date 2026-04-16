part of 'exploration_bloc.dart';

sealed class ExplorationEvent extends Equatable {
  const ExplorationEvent();

  @override
  List<Object> get props => [];
}

class ExplorationWatchStarted extends ExplorationEvent {}

class _UserPositionUpdated extends ExplorationEvent {
  final UserPosition userPosition;

  const _UserPositionUpdated(this.userPosition);

  @override
  List<Object> get props => [userPosition];
}

class ExplorationRotationPreferenceToggled extends ExplorationEvent {
  final bool enabled;

  const ExplorationRotationPreferenceToggled({required this.enabled});

  @override
  List<Object> get props => [enabled];
}

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

class _MapRegionsLoaded extends ExplorationEvent {
  final List<ExplorationMapRegion> mapRegions;

  const _MapRegionsLoaded(this.mapRegions);

  @override
  List<Object> get props => [mapRegions];
}

class _MapRegionsFailed extends ExplorationEvent {
  final String message;

  const _MapRegionsFailed(this.message);

  @override
  List<Object> get props => [message];
}

class _RotationPreferenceLoaded extends ExplorationEvent {
  final bool enabled;

  const _RotationPreferenceLoaded(this.enabled);

  @override
  List<Object> get props => [enabled];
}

class _RotationPreferenceFailed extends ExplorationEvent {
  final String message;

  const _RotationPreferenceFailed(this.message);

  @override
  List<Object> get props => [message];
}

class _MapTileCacheSizeLoaded extends ExplorationEvent {
  final int bytes;

  const _MapTileCacheSizeLoaded(this.bytes);

  @override
  List<Object> get props => [bytes];
}

class _MapTileCacheSizeFailed extends ExplorationEvent {
  final String message;

  const _MapTileCacheSizeFailed(this.message);

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

class ExplorationCaptureRequested extends ExplorationEvent {
  final String plantId;

  const ExplorationCaptureRequested({required this.plantId});

  @override
  List<Object> get props => [plantId];
}

class ExplorationNearbyPlantDetectionCleared extends ExplorationEvent {}
