import 'package:dartz/dartz.dart' show Either;
import 'package:equatable/equatable.dart' show Equatable;

import '../errors/failures.dart';

abstract class StreamUsecase<T, Params> {
  Stream<Either<Failure, T>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
