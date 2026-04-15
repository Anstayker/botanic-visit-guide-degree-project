import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';

import '../../entities/user_position.dart';
import '../../errors/failures.dart';
import 'compass_wrapper.dart';
import 'geolocator_wrapper.dart';

abstract class LocationService {
  Stream<Either<Failure, UserPosition>> watchUserPosition();
  Future<bool> isLocationEnabled();
  Future<void> requestLocationPermission();
  double distanceBetween({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  });
  double bearingBetween({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  });
}

class LocationServiceImpl extends LocationService {
  final GeolocatorWrapper geolocator;
  final CompassWrapper compass;

  LocationServiceImpl({required this.geolocator, required this.compass});

  @override
  Future<bool> isLocationEnabled() {
    return geolocator.isLocationServiceEnabled();
  }

  @override
  Future<void> requestLocationPermission() async {
    final permission = await geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw StateError('Location permission denied.');
    }
  }

  @override
  Stream<Either<Failure, UserPosition>> watchUserPosition() async* {
    try {
      final enabled = await isLocationEnabled();
      if (!enabled) {
        yield const Left(
          UnknownFailure('Location service is disabled on this device.'),
        );
        return;
      }

      final permission = await geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        try {
          await requestLocationPermission();
        } on StateError {
          yield const Left(UnknownFailure('Location permission denied.'));
          return;
        }
      }

      final currentPermission = await geolocator.checkPermission();
      if (currentPermission == LocationPermission.denied ||
          currentPermission == LocationPermission.deniedForever) {
        yield const Left(
          UnknownFailure('Location permission denied or permanently denied.'),
        );
        return;
      }

      final headingStream = compass.watchHeading().startWith(0.0);
      const positionSettings = LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 1,
      );

      yield* Rx.combineLatest2<Position, double, Either<Failure, UserPosition>>(
        geolocator.getPositionStream(locationSettings: positionSettings),
        headingStream,
        (Position position, double heading) => Right<Failure, UserPosition>(
          UserPosition(
            latitude: position.latitude,
            longitude: position.longitude,
            heading: _normalizeHeading(heading),
          ),
        ),
      ).onErrorReturnWith(
        (error, _) => Left<Failure, UserPosition>(
          UnknownFailure('Unable to track location in real time: $error'),
        ),
      );
    } catch (error) {
      yield Left(UnknownFailure('Unexpected location service error: $error'));
    }
  }

  double _normalizeHeading(double heading) {
    return (heading % 360 + 360) % 360;
  }

  @override
  double distanceBetween({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return geolocator.distanceBetween(
      startLatitude: startLatitude,
      startLongitude: startLongitude,
      endLatitude: endLatitude,
      endLongitude: endLongitude,
    );
  }

  @override
  double bearingBetween({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return geolocator.bearingBetween(
      startLatitude: startLatitude,
      startLongitude: startLongitude,
      endLatitude: endLatitude,
      endLongitude: endLongitude,
    );
  }
}
