import 'package:equatable/equatable.dart';

import '../../../../core/entities/plant.dart';

class ExplorationPlant extends Equatable {
  final Plant plant;
  final double distance; // in meters, from the user's current position
  final double bearing; // in degrees, from the user's current heading
  final bool isVisibleInRadar;

  const ExplorationPlant({
    required this.plant,
    required this.distance,
    required this.bearing,
    required this.isVisibleInRadar,
  });

  @override
  List<Object?> get props => [plant, distance, bearing, isVisibleInRadar];
}
