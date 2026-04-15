import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/radar_preferences_repository.dart';

class GetMapTileCacheMaxSizeBytes implements Usecase<int, NoParams> {
  final RadarPreferencesRepository repository;

  GetMapTileCacheMaxSizeBytes({required this.repository});

  @override
  Future<Either<Failure, int>> call(NoParams params) {
    return repository.getMapTileCacheMaxSizeBytes();
  }
}
