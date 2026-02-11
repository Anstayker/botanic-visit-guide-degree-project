import 'package:dartz/dartz.dart' show Either;

import '../../../../core/entities/plant.dart';
import '../../../../core/errors/failures.dart';
import '../entities/ency_plant.dart';
import '../entities/plant_filter_params.dart';

abstract class EncyRepository {
  Future<Either<Failure, List<EncyPlant>>> getAllPlants();
  Future<Either<Failure, List<EncyPlant>>> getPlantsByCategory(int categoryId);
  Stream<Either<Failure, List<Plant>>> watchAllPlantsInfo(
    PlantFilterParams plantFilterParams,
  );
}
