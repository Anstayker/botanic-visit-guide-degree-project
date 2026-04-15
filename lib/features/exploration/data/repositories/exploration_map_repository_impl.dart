import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/exploration_map_region.dart';
import '../../domain/repositories/exploration_map_repository.dart';
import '../datasources/exploration_map_local_data_source.dart';

class ExplorationMapRepositoryImpl implements ExplorationMapRepository {
  final ExplorationMapLocalDataSource localDataSource;

  ExplorationMapRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<ExplorationMapRegion>>>
  getRecommendedMapRegions() async {
    try {
      final regions = await localDataSource.getRecommendedMapRegions();
      return Right(regions);
    } catch (error) {
      return Left(UnknownFailure('Unable to build map regions: $error'));
    }
  }
}
