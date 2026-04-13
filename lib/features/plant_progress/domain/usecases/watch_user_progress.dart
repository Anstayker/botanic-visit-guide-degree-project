import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/stream_usecase.dart';
import '../entities/plant_discovery_progress.dart';
import '../repositories/plant_progress_repository.dart';

class WatchUserProgress
    implements StreamUsecase<PlantDiscoveryProgress, NoParams> {
  final PlantProgressRepository repository;

  WatchUserProgress({required this.repository});

  @override
  Stream<Either<Failure, PlantDiscoveryProgress>> call(NoParams params) {
    return repository.watchUserProgress();
  }
}
