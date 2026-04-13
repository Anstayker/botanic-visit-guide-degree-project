import 'package:dartz/dartz.dart';

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
    } catch (e) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> setAllPlantsDiscovered(
    bool isDiscovered,
  ) async {
    try {
      await localDataSource.setAllPlantsDiscovered(isDiscovered);
      return right(null);
    } catch (e) {
      return left(UnknownFailure());
    }
  }

  @override
  Stream<Either<Failure, PlantDiscoveryProgress>> watchUserProgress() async* {
    try {
      await for (final progress in localDataSource.watchUserProgress()) {
        yield right(progress);
      }
    } catch (e) {
      yield left(UnknownFailure());
    }
  }
}
