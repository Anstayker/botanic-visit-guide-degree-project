import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/entities/user_position.dart';
import '../../../../core/services/location/location_service.dart';
import '../../domain/entities/exploration_plant.dart';
import '../../domain/repositories/exploration_repository.dart';
import '../datasources/exploration_local_datasource.dart';

class ExplorationRepositoryImpl extends ExplorationRepository {
  static const double _maxRadarDistanceMeters = 100;
  static const double _radarFovDegrees = 360;

  ExplorationLocalDataSource localDataSource;
  LocationService locationService;

  ExplorationRepositoryImpl({
    required this.localDataSource,
    required this.locationService,
  });

  @override
  Stream<Either<Failure, List<ExplorationPlant>>> watchNearbyPlants() {
    return Rx.combineLatest2(
      locationService.watchUserPosition(),
      localDataSource.getExplorationData(),
      (
        Either<Failure, UserPosition> positionResult,
        List<ExplorationPlant> plants,
      ) {
        return positionResult.fold((failure) => Left(failure), (userPos) {
          final nearbyPlants =
              plants
                  .map((explorationPlant) {
                    final plantLatitude =
                        explorationPlant.plant.location.latitude;
                    final plantLongitude =
                        explorationPlant.plant.location.longitude;

                    final distance = locationService.distanceBetween(
                      startLatitude: userPos.latitude,
                      startLongitude: userPos.longitude,
                      endLatitude: plantLatitude,
                      endLongitude: plantLongitude,
                    );

                    final absoluteBearing = locationService.bearingBetween(
                      startLatitude: userPos.latitude,
                      startLongitude: userPos.longitude,
                      endLatitude: plantLatitude,
                      endLongitude: plantLongitude,
                    );

                    final relativeBearing = _toRelativeBearing(
                      absoluteBearing: absoluteBearing,
                      userHeading: userPos.heading,
                    );

                    return ExplorationPlant(
                      plant: explorationPlant.plant,
                      distance: distance,
                      bearing: relativeBearing,
                      isVisibleInRadar: _isVisibleInRadar(
                        distance: distance,
                        relativeBearing: relativeBearing,
                      ),
                    );
                  })
                  .where((plant) => plant.distance <= _maxRadarDistanceMeters)
                  .toList()
                ..sort((a, b) => a.distance.compareTo(b.distance));
          return Right(nearbyPlants);
        });
      },
    );
  }

  double _toRelativeBearing({
    required double absoluteBearing,
    required double userHeading,
  }) {
    final normalizedAbsolute = _normalizeBearing(absoluteBearing);
    final normalizedHeading = _normalizeBearing(userHeading);

    return _normalizeBearing(normalizedAbsolute - normalizedHeading);
  }

  double _normalizeBearing(double value) {
    return (value % 360 + 360) % 360;
  }

  bool _isVisibleInRadar({
    required double distance,
    required double relativeBearing,
  }) {
    if (distance > _maxRadarDistanceMeters) {
      return false;
    }

    final halfFov = _radarFovDegrees / 2;
    final angleFromForward = relativeBearing > 180
        ? 360 - relativeBearing
        : relativeBearing;

    return angleFromForward <= halfFov;
  }

  @override
  Future<Either<Failure, List<ExplorationPlant>>> triggerSonarPing() {
    // TODO: implement triggerSonarPing
    throw UnimplementedError();
  }
}
