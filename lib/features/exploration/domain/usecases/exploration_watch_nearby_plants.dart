import 'package:botanic_guide/features/exploration/domain/entities/exploration_plant.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/stream_usecase.dart';
import '../repositories/exploration_repository.dart';

class ExplorationWatchNearbyPlants
    implements StreamUsecase<List<ExplorationPlant>, NoParams> {
  final ExplorationRepository repository;

  ExplorationWatchNearbyPlants({required this.repository});

  @override
  Stream<Either<Failure, List<ExplorationPlant>>> call(NoParams params) {
    return repository.watchNearbyPlants();
  }
}
