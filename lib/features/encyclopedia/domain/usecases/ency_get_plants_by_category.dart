import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/ency_plant.dart';
import '../repositories/ency_repository.dart';

class EncyGetPlantsByCategory implements Usecase<List<EncyPlant>, Params> {
  final EncyRepository repository;

  EncyGetPlantsByCategory({required this.repository});

  @override
  Future<Either<Failure, List<EncyPlant>>> call(Params params) async {
    return await repository.getPlantsByCategory(params.categoryId);
  }
}

class Params extends Equatable {
  final int categoryId;

  const Params({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}
