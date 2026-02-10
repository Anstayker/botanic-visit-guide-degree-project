import 'package:botanic_guide/core/errors/failures.dart';
import 'package:dartz/dartz.dart' show Either;

import '../entities/ency_plant.dart';

abstract class EncyRepository {
  Future<Either<Failure, List<EncyPlant>>> getAllPlants();
  Future<Either<Failure, List<EncyPlant>>> getPlantsByCategory(int categoryId);
}
