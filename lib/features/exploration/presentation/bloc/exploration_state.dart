part of 'exploration_bloc.dart';

// Implementacion con 1 solo estado, es correcto?
enum ExplorationStatus { initial, loading, success, error }

class ExplorationState extends Equatable {
  static const Object _sentinel = Object();

  final ExplorationStatus status;
  final UserPosition? userPosition;
  final List<ExplorationPlant> plants;
  final List<ExplorationMapRegion> mapRegions;
  final int mapTileCacheMaxSizeBytes;
  final ExplorationPlant? nearbyPlantDetected;
  final bool isSonarActive;
  final bool isHeadingRotationEnabled;
  final String? errorMessage;

  const ExplorationState({
    this.status = ExplorationStatus.initial,
    this.userPosition,
    this.plants = const [],
    this.mapRegions = const [],
    this.mapTileCacheMaxSizeBytes = 80 * 1024 * 1024,
    this.nearbyPlantDetected,
    this.isSonarActive = false,
    this.isHeadingRotationEnabled = false,
    this.errorMessage,
  });

  ExplorationState copyWith({
    ExplorationStatus? status,
    Object? userPosition = _sentinel,
    List<ExplorationPlant>? plants,
    List<ExplorationMapRegion>? mapRegions,
    int? mapTileCacheMaxSizeBytes,
    Object? nearbyPlantDetected = _sentinel,
    bool? isSonarActive,
    bool? isHeadingRotationEnabled,
    Object? errorMessage = _sentinel,
  }) {
    return ExplorationState(
      status: status ?? this.status,
      userPosition: userPosition == _sentinel
          ? this.userPosition
          : userPosition as UserPosition?,
      plants: plants ?? this.plants,
      mapRegions: mapRegions ?? this.mapRegions,
      mapTileCacheMaxSizeBytes:
          mapTileCacheMaxSizeBytes ?? this.mapTileCacheMaxSizeBytes,
      nearbyPlantDetected: nearbyPlantDetected == _sentinel
          ? this.nearbyPlantDetected
          : nearbyPlantDetected as ExplorationPlant?,
      isSonarActive: isSonarActive ?? this.isSonarActive,
      isHeadingRotationEnabled:
          isHeadingRotationEnabled ?? this.isHeadingRotationEnabled,
      errorMessage: errorMessage == _sentinel
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    userPosition,
    plants,
    mapRegions,
    mapTileCacheMaxSizeBytes,
    nearbyPlantDetected,
    isSonarActive,
    isHeadingRotationEnabled,
    errorMessage,
  ];
}
