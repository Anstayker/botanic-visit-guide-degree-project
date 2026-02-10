import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/ency_plant.dart';
import '../../domain/repositories/ency_repository.dart';
import '../datasources/ency_local_datasource.dart';

class EncyRepositoryImpl implements EncyRepository {
  EncyLocalDatasource localDatasource;

  EncyRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Failure, List<EncyPlant>>> getAllPlants() async {
    try {
      final result = await localDatasource.getAllPlants();
      return right(result);
    } on UnknownFailure {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<EncyPlant>>> getPlantsByCategory(
    int categoryId,
  ) async {
    try {
      final result = await localDatasource.getPlantsByCategory(categoryId);
      return right(result);
    } on UnknownFailure {
      return left(UnknownFailure());
    }
  }
}
