import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/exploration_map_region.dart';

abstract class ExplorationMapRepository {
  Future<Either<Failure, List<ExplorationMapRegion>>>
  getRecommendedMapRegions();
}
