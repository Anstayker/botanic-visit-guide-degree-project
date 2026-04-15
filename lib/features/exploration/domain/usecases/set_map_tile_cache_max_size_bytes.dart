import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/radar_preferences_repository.dart';

class SetMapTileCacheMaxSizeBytes implements Usecase<int, Params> {
  final RadarPreferencesRepository repository;

  SetMapTileCacheMaxSizeBytes({required this.repository});

  @override
  Future<Either<Failure, int>> call(Params params) {
    return repository.setMapTileCacheMaxSizeBytes(params.bytes);
  }
}

class Params extends Equatable {
  final int bytes;

  const Params({required this.bytes});

  @override
  List<Object?> get props => [bytes];
}
