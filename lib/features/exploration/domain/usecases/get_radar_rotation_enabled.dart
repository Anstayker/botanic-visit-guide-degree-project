import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/radar_preferences_repository.dart';

class GetRadarRotationEnabled implements Usecase<bool, NoParams> {
  final RadarPreferencesRepository repository;

  GetRadarRotationEnabled({required this.repository});

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.getHeadingRotationEnabled();
  }
}
