import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/plant_progress_repository.dart';

class DiscoverPlant implements Usecase<void, Params> {
  PlantProgressRepository repository;

  DiscoverPlant({required this.repository});

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await repository.discoverPlant(params.plantId);
  }
}

class Params {
  final String plantId;

  const Params({required this.plantId});
}
