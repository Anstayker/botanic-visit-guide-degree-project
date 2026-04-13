import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/plant_progress_repository.dart';

class SetAllPlantsDiscovered implements Usecase<void, Params> {
  final PlantProgressRepository repository;

  SetAllPlantsDiscovered({required this.repository});

  @override
  Future<Either<Failure, void>> call(Params params) {
    return repository.setAllPlantsDiscovered(params.isDiscovered);
  }
}

class Params extends Equatable {
  final bool isDiscovered;

  const Params({required this.isDiscovered});

  @override
  List<Object?> get props => [isDiscovered];
}
