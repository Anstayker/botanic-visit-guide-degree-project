import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/exploration_plant.dart';

abstract class ExplorationRepository {
  Stream<Either<Failure, List<ExplorationPlant>>> watchNearbyPlants();
  //! Method Only in Bloc?
  Future<Either<Failure, List<ExplorationPlant>>> triggerSonarPing();
  Future<Either<Failure, void>> unlockPlant(String plantId);
}
