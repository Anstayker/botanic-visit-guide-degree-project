import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/plant_discovery_progress.dart';
import '../../domain/repositories/plant_progress_repository.dart';
import '../datasources/plant_progress_local_datasource.dart';

class PlantProgressRepositoryImpl implements PlantProgressRepository {
  PlantProgressLocalDataSource localDataSource;

  PlantProgressRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> discoverPlant(String plantId) async {
    try {
      await localDataSource.discoverPlant(plantId);
      return right(null);
    } catch (exception) {
      return left(_mapExceptionToFailure(exception));
    }
  }

  @override
  Future<Either<Failure, void>> setAllPlantsDiscovered(
    bool isDiscovered,
  ) async {
    try {
      await localDataSource.setAllPlantsDiscovered(isDiscovered);
      return right(null);
    } catch (exception) {
      return left(_mapExceptionToFailure(exception));
    }
  }

  @override
  Stream<Either<Failure, PlantDiscoveryProgress>> watchUserProgress() async* {
    try {
      await for (final progress in localDataSource.watchUserProgress()) {
        yield right(progress);
      }
    } catch (exception) {
      yield left(_mapExceptionToFailure(exception));
    }
  }

  Failure _mapExceptionToFailure(Object exception) {
    if (exception is PlantNotFoundException) {
      return PlantNotFoundFailure(exception.message);
    }

    if (exception is CacheException) {
      return CacheFailure(exception.message);
    }

    if (exception is DataParsingException) {
      return DataParsingFailure(exception.message);
    }

    if (exception is UnknownException) {
      return UnknownFailure(exception.message);
    }

    return UnknownFailure('Unexpected error type: $exception');
  }
}
