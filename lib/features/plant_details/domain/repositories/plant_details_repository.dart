import 'package:dartz/dartz.dart';

import '../../../../core/entities/plant.dart';
import '../../../../core/errors/failures.dart';

abstract class PlantDetailsRepository {
  Future<Either<Failure, Plant>> getPlantDetailsData(String plantId);
}
