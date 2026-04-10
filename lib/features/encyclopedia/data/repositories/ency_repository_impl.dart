import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/entities/plant.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/plant_filter_params.dart';
import '../../domain/repositories/ency_repository.dart';
import '../datasources/ency_local_datasource.dart';
import '../services/ency_plants_sync_service.dart';

class EncyRepositoryImpl implements EncyRepository {
  EncyLocalDataSource localDatasource;
  EncyPlantsSyncService syncService;

  EncyRepositoryImpl({
    required this.localDatasource,
    required this.syncService,
  });

  @override
  Stream<Either<Failure, List<Plant>>> watchAllPlantsInfo(
    PlantFilterParams plantFilterParams,
  ) async* {
    try {
      unawaited(syncService.syncIfNeeded());

      await for (final plants in localDatasource.watchAllPlantsInfo(
        plantFilterParams,
      )) {
        yield right(plants);
      }
    } on UnknownFailure {
      yield left(UnknownFailure());
    }
  }
}
