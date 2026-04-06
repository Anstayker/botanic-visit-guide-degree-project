import 'package:dartz/dartz.dart' show Either;

import '../../../../core/entities/plant.dart';
import '../../../../core/errors/failures.dart';
import '../entities/plant_filter_params.dart';

abstract class EncyRepository {
  Stream<Either<Failure, List<Plant>>> watchAllPlantsInfo(
    PlantFilterParams plantFilterParams,
  );
}
