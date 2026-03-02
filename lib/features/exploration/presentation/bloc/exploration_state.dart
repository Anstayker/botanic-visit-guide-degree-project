part of 'exploration_bloc.dart';

// Implementacion con 1 solo estado, es correcto?
enum ExplorationStatus { initial, loading, success, error }

class ExplorationState extends Equatable {
  static const Object _sentinel = Object();

  final ExplorationStatus status;
  final UserPosition? userPosition;
  final List<ExplorationPlant> plants;
  final ExplorationPlant? nearbyPlantDetected;
  final bool isSonarActive;
  final String? errorMessage;

  const ExplorationState({
    this.status = ExplorationStatus.initial,
    this.userPosition,
    this.plants = const [],
    this.nearbyPlantDetected,
    this.isSonarActive = false,
    this.errorMessage,
  });

  ExplorationState copyWith({
    ExplorationStatus? status,
    Object? userPosition = _sentinel,
    List<ExplorationPlant>? plants,
    Object? nearbyPlantDetected = _sentinel,
    bool? isSonarActive,
    Object? errorMessage = _sentinel,
  }) {
    return ExplorationState(
      status: status ?? this.status,
      userPosition: userPosition == _sentinel
          ? this.userPosition
          : userPosition as UserPosition?,
      plants: plants ?? this.plants,
      nearbyPlantDetected: nearbyPlantDetected == _sentinel
          ? this.nearbyPlantDetected
          : nearbyPlantDetected as ExplorationPlant?,
      isSonarActive: isSonarActive ?? this.isSonarActive,
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
    nearbyPlantDetected,
    isSonarActive,
    errorMessage,
  ];
}
