import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

abstract class RadarPreferencesRepository {
  Future<Either<Failure, bool>> getHeadingRotationEnabled();
  Future<Either<Failure, bool>> setHeadingRotationEnabled(bool enabled);
  Future<Either<Failure, int>> getMapTileCacheMaxSizeBytes();
  Future<Either<Failure, int>> setMapTileCacheMaxSizeBytes(int bytes);
}
