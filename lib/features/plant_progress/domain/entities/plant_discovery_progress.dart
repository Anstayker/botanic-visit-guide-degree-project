import 'package:equatable/equatable.dart';

class PlantDiscoveryProgress extends Equatable {
  final int totalPlants;
  final int discoveredPlants;

  const PlantDiscoveryProgress({
    required this.totalPlants,
    required this.discoveredPlants,
  });

  int get progressPercentage {
    if (totalPlants == 0) {
      return 0;
    }

    final percentage = (discoveredPlants * 100) ~/ totalPlants;
    return percentage.clamp(0, 100);
  }

  double get progressValue {
    if (totalPlants == 0) {
      return 0;
    }

    return (discoveredPlants / totalPlants).clamp(0, 1);
  }

  @override
  List<Object?> get props => [totalPlants, discoveredPlants];
}
