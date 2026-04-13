import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/plant_discovery_progress.dart';

abstract class PlantProgressRepository {
  Future<Either<Failure, void>> discoverPlant(String plantId);
  Future<Either<Failure, void>> setAllPlantsDiscovered(bool isDiscovered);
  Stream<Either<Failure, PlantDiscoveryProgress>> watchUserProgress();
}
