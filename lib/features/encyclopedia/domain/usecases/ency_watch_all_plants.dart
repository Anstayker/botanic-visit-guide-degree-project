import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/entities/plant.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/stream_usecase.dart';
import '../entities/plant_filter_params.dart';
import '../repositories/ency_repository.dart';

class EncyWatchAllPlants implements StreamUsecase<List<Plant>, Params> {
  final EncyRepository repository;

  EncyWatchAllPlants({required this.repository});

  @override
  Stream<Either<Failure, List<Plant>>> call(Params params) {
    return repository.watchAllPlantsInfo(params.filterParams);
  }
}

class Params extends Equatable {
  final PlantFilterParams filterParams;

  const Params({required this.filterParams});

  @override
  List<Object?> get props => [filterParams];
}
