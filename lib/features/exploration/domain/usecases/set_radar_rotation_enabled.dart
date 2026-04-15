import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/radar_preferences_repository.dart';

class SetRadarRotationEnabled implements Usecase<bool, Params> {
  final RadarPreferencesRepository repository;

  SetRadarRotationEnabled({required this.repository});

  @override
  Future<Either<Failure, bool>> call(Params params) {
    return repository.setHeadingRotationEnabled(params.enabled);
  }
}

class Params extends Equatable {
  final bool enabled;

  const Params({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}
