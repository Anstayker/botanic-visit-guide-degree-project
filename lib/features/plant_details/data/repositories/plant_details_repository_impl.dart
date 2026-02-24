import 'package:dartz/dartz.dart';

import '../../../../core/entities/plant.dart';
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
    } catch (e) {
      return left(UnknownFailure());
    }
  }
}
