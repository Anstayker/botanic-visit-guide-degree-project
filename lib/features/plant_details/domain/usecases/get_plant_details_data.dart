import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/entities/plant.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/plant_details_repository.dart';

class GetPlantDetailsData implements Usecase<Plant, Params> {
  final PlantDetailsRepository repository;

  GetPlantDetailsData({required this.repository});

  @override
  Future<Either<Failure, Plant>> call(Params params) async {
    return await repository.getPlantDetailsData(params.id);
  }
}

class Params extends Equatable {
  final String id;

  const Params({required this.id});

  @override
  List<Object?> get props => [id];
}
