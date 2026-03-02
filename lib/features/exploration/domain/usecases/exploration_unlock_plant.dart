import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/exploration_repository.dart';

class ExplorationUnlockPlant implements Usecase<void, Params> {
  final ExplorationRepository repository;

  ExplorationUnlockPlant({required this.repository});

  @override
  Future<Either<Failure, void>> call(Params params) {
    return repository.unlockPlant(params.plantId);
  }
}

class Params {
  final String plantId;

  const Params({required this.plantId});
}
