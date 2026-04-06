import 'package:dartz/dartz.dart';

import '../../../../core/entities/plant.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/plant_filter_params.dart';
import '../../domain/repositories/ency_repository.dart';
import '../datasources/ency_local_datasource.dart';

class EncyRepositoryImpl implements EncyRepository {
  EncyLocalDataSource localDatasource;

  EncyRepositoryImpl({required this.localDatasource});

  @override
  Stream<Either<Failure, List<Plant>>> watchAllPlantsInfo(
    PlantFilterParams plantFilterParams,
  ) async* {
    try {
      await for (final plants in localDatasource.watchAllPlantsInfo(
        plantFilterParams,
      )) {
        yield right(plants);
      }
    } on UnknownFailure {
      yield left(UnknownFailure());
    }
  }
}
