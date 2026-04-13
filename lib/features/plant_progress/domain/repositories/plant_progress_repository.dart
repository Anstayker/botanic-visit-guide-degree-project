import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

abstract class PlantProgressRepository {
  Future<Either<Failure, void>> discoverPlant(String plantId);
}
