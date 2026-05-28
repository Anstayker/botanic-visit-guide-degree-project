import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../plant_details/domain/repositories/plant_details_repository.dart';
import '../../domain/repositories/qr_scanner_repository.dart';
import '../datasources/qr_scanner_local_datasource.dart';

class QrScannerRepositoryImpl implements QrScannerRepository {
  QrScannerRepositoryImpl({
    required this.localDatasource,
    required this.plantDetailsRepository,
  });

  final QrScannerLocalDatasource localDatasource;
  final PlantDetailsRepository plantDetailsRepository;

  @override
  Future<Either<Failure, String>> validateQrCode(String rawValue) async {
    try {
      final qrCode = localDatasource.validateRawValue(rawValue);
      final plantResult = await plantDetailsRepository.getPlantDetailsData(
        qrCode.plantId,
      );

      return plantResult.fold(
        (failure) => left(
          failure is UnknownFailure ? const PlantNotFoundFailure() : failure,
        ),
        (_) => right(qrCode.plantId),
      );
    } on DataParsingException catch (exception) {
      return left(InvalidQrCodeFailure(exception.message));
    } catch (exception) {
      return left(
        UnknownFailure('Unexpected error validating QR code: $exception'),
      );
    }
  }
}
