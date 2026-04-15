import 'dart:math' as math;

import 'package:hive/hive.dart';

import '../../../../core/data/models/plant_model.dart';
import '../../domain/entities/exploration_map_region.dart';

abstract class ExplorationMapLocalDataSource {
  Future<List<ExplorationMapRegion>> getRecommendedMapRegions();
}

class ExplorationMapLocalDataSourceImpl
    implements ExplorationMapLocalDataSource {
  static const double _fallbackCenterLatitude = -17.3866;
  static const double _fallbackCenterLongitude = -66.1984;
  static const double _minimumPaddingDegrees = 0.00035;
  static const double _paddingFactor = 0.18;
  static const double _minimumZoom = 16.0;
  static const double _maximumZoom = 20.0;

  final Box<PlantModel> plantBox;

  ExplorationMapLocalDataSourceImpl({required this.plantBox});

  @override
  Future<List<ExplorationMapRegion>> getRecommendedMapRegions() async {
    final locations = plantBox.values
        .map((plant) => plant.plantLocation)
        .toList(growable: false);

    if (locations.isEmpty) {
      return [_buildFallbackRegion()];
    }

    final latitudes = locations.map((location) => location.latitude).toList();
    final longitudes = locations.map((location) => location.longitude).toList();

    final minLatitude = latitudes.reduce(math.min);
    final maxLatitude = latitudes.reduce(math.max);
    final minLongitude = longitudes.reduce(math.min);
    final maxLongitude = longitudes.reduce(math.max);

    final latitudeSpan = maxLatitude - minLatitude;
    final longitudeSpan = maxLongitude - minLongitude;
    final latitudePadding = math.max(
      latitudeSpan * _paddingFactor,
      _minimumPaddingDegrees,
    );
    final longitudePadding = math.max(
      longitudeSpan * _paddingFactor,
      _minimumPaddingDegrees,
    );
    final longestSpan = math.max(latitudeSpan, longitudeSpan);

    return [
      ExplorationMapRegion(
        id: 'botanical_garden_primary',
        name: 'Jardín Botánico',
        centerLatitude: (minLatitude + maxLatitude) / 2,
        centerLongitude: (minLongitude + maxLongitude) / 2,
        southWestLatitude: minLatitude - latitudePadding,
        southWestLongitude: minLongitude - longitudePadding,
        northEastLatitude: maxLatitude + latitudePadding,
        northEastLongitude: maxLongitude + longitudePadding,
        recommendedZoom: _recommendedZoomForSpan(longestSpan),
        minimumZoom: _minimumZoom,
        maximumZoom: _maximumZoom,
        shouldPrecache: true,
        priority: 100,
      ),
    ];
  }

  ExplorationMapRegion _buildFallbackRegion() {
    return ExplorationMapRegion(
      id: 'botanical_garden_primary',
      name: 'Jardín Botánico',
      centerLatitude: _fallbackCenterLatitude,
      centerLongitude: _fallbackCenterLongitude,
      southWestLatitude: _fallbackCenterLatitude - 0.0015,
      southWestLongitude: _fallbackCenterLongitude - 0.0015,
      northEastLatitude: _fallbackCenterLatitude + 0.0015,
      northEastLongitude: _fallbackCenterLongitude + 0.0015,
      recommendedZoom: 18.0,
      minimumZoom: _minimumZoom,
      maximumZoom: _maximumZoom,
      shouldPrecache: true,
      priority: 100,
    );
  }

  double _recommendedZoomForSpan(double spanDegrees) {
    if (spanDegrees <= 0.0006) {
      return 18.5;
    }

    if (spanDegrees <= 0.0012) {
      return 18.0;
    }

    if (spanDegrees <= 0.0025) {
      return 17.5;
    }

    return 16.8;
  }
}
