import 'package:equatable/equatable.dart';

class ExplorationMapRegion extends Equatable {
  final String id;
  final String name;
  final double centerLatitude;
  final double centerLongitude;
  final double southWestLatitude;
  final double southWestLongitude;
  final double northEastLatitude;
  final double northEastLongitude;
  final double recommendedZoom;
  final double minimumZoom;
  final double maximumZoom;
  final bool shouldPrecache;
  final int priority;

  const ExplorationMapRegion({
    required this.id,
    required this.name,
    required this.centerLatitude,
    required this.centerLongitude,
    required this.southWestLatitude,
    required this.southWestLongitude,
    required this.northEastLatitude,
    required this.northEastLongitude,
    required this.recommendedZoom,
    required this.minimumZoom,
    required this.maximumZoom,
    required this.shouldPrecache,
    required this.priority,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    centerLatitude,
    centerLongitude,
    southWestLatitude,
    southWestLongitude,
    northEastLatitude,
    northEastLongitude,
    recommendedZoom,
    minimumZoom,
    maximumZoom,
    shouldPrecache,
    priority,
  ];
}
