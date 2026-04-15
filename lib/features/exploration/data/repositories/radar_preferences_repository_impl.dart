import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/repositories/radar_preferences_repository.dart';
import '../datasources/radar_preferences_local_data_source.dart';

class RadarPreferencesRepositoryImpl implements RadarPreferencesRepository {
  final RadarPreferencesLocalDataSource localDataSource;

  RadarPreferencesRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, bool>> getHeadingRotationEnabled() async {
    try {
      final enabled = await localDataSource.isHeadingRotationEnabled();
      return Right(enabled);
    } catch (error) {
      return Left(
        UnknownFailure('Unable to read radar rotation preference: $error'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> setHeadingRotationEnabled(bool enabled) async {
    try {
      await localDataSource.setHeadingRotationEnabled(enabled);
      return Right(enabled);
    } catch (error) {
      return Left(
        UnknownFailure('Unable to store radar rotation preference: $error'),
      );
    }
  }

  @override
  Future<Either<Failure, int>> getMapTileCacheMaxSizeBytes() async {
    try {
      final bytes = await localDataSource.getMapTileCacheMaxSizeBytes();
      return Right(bytes);
    } catch (error) {
      return Left(
        UnknownFailure('Unable to read map tile cache size preference: $error'),
      );
    }
  }

  @override
  Future<Either<Failure, int>> setMapTileCacheMaxSizeBytes(int bytes) async {
    try {
      await localDataSource.setMapTileCacheMaxSizeBytes(bytes);
      return Right(bytes);
    } catch (error) {
      return Left(
        UnknownFailure(
          'Unable to store map tile cache size preference: $error',
        ),
      );
    }
  }
}
