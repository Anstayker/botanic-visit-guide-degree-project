import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
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
    } catch (exception) {
      return Left(_mapExceptionToFailure(exception));
    }
  }

  Failure _mapExceptionToFailure(Object exception) {
    if (exception is CacheException) {
      return CacheFailure(exception.message);
    }

    if (exception is DataParsingException) {
      return DataParsingFailure(exception.message);
    }

    if (exception is UnknownException) {
      return UnknownFailure(exception.message);
    }

    return UnknownFailure('Unable to build map regions: $exception');
  }
}
