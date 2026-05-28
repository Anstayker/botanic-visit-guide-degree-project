import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/qr_scanner_repository.dart';

class ValidateQrCode implements Usecase<String, Params> {
  final QrScannerRepository repository;

  ValidateQrCode({required this.repository});

  @override
  Future<Either<Failure, String>> call(Params params) async {
    return await repository.validateQrCode(params.rawValue);
  }
}

class Params extends Equatable {
  final String rawValue;

  const Params({required this.rawValue});

  @override
  List<Object?> get props => [rawValue];
}
