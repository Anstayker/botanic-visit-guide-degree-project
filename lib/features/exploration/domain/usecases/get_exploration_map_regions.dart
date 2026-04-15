import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/exploration_map_region.dart';
import '../repositories/exploration_map_repository.dart';

class GetExplorationMapRegions
    implements Usecase<List<ExplorationMapRegion>, NoParams> {
  final ExplorationMapRepository repository;

  GetExplorationMapRegions({required this.repository});

  @override
  Future<Either<Failure, List<ExplorationMapRegion>>> call(NoParams params) {
    return repository.getRecommendedMapRegions();
  }
}
