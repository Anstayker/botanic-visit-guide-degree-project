import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/ency_plant.dart';
import '../repositories/ency_repository.dart';

class EncyGetAllPlants implements Usecase<List<EncyPlant>, NoParams> {
  final EncyRepository repository;

  EncyGetAllPlants({required this.repository});

  @override
  Future<Either<Failure, List<EncyPlant>>> call(NoParams params) async {
    return await repository.getAllPlants();
  }
}
