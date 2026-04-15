import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure([this.message = 'An unexpected error occurred.']);

  @override
  List<Object?> get props => [message];
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unknown error occurred.']);

  @override
  String toString() => 'UnknownFailure: $message';
}

class InvalidQrCodeFailure extends Failure {
  const InvalidQrCodeFailure([super.message = 'El QR escaneado no es valido.']);

  @override
  String toString() => 'InvalidQrCodeFailure: $message';
}

class PlantNotFoundFailure extends Failure {
  const PlantNotFoundFailure([
    super.message = 'No se encontro una planta asociada a este QR.',
  ]);

  @override
  String toString() => 'PlantNotFoundFailure: $message';
}
