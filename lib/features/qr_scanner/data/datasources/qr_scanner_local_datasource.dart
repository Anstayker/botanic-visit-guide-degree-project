import '../../../../core/errors/exceptions.dart';
import '../models/qr_code_model.dart';

abstract class QrScannerLocalDatasource {
  QrCodeModel validateRawValue(String rawValue);
}

class QrScannerLocalDatasourceImpl implements QrScannerLocalDatasource {
  @override
  QrCodeModel validateRawValue(String rawValue) {
    try {
      return QrCodeModel.fromRawValue(rawValue);
    } on FormatException catch (exception) {
      throw DataParsingException(exception.message);
    } catch (exception) {
      throw DataParsingException('Failed to validate QR code: $exception');
    }
  }
}
