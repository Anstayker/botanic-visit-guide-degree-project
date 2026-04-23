import 'package:dartz/dartz.dart';

import '../../../../core/entities/plant.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/plant_details_repository.dart';
import '../datasources/plant_details_localdatasource.dart';

class PlantDetailsRepositoryImpl implements PlantDetailsRepository {
  PlantDetailsLocalDatasource localDatasource;

  PlantDetailsRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Failure, Plant>> getPlantDetailsData(String plantId) async {
    try {
      final plantData = await localDatasource.getPlantDetailsData(plantId);
      return right(plantData);
    } catch (exception) {
      return left(_mapExceptionToFailure(exception));
    }
  }

  Failure _mapExceptionToFailure(Object exception) {
    if (exception is PlantNotFoundException) {
      return PlantNotFoundFailure(exception.message);
    }

    if (exception is CacheException) {
      return CacheFailure(exception.message);
    }

    if (exception is UnknownException) {
      return UnknownFailure(exception.message);
    }

    return UnknownFailure('Unexpected error type: $exception');
  }
}
