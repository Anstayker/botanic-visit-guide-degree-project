abstract class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

class UnknownException extends AppException {
  const UnknownException([super.message = 'An unknown error occurred.']);
}

class RemoteDataException extends AppException {
  const RemoteDataException([super.message = 'A remote data error occurred.']);
}

class CacheException extends AppException {
  const CacheException([super.message = 'A local cache error occurred.']);
}

class DataParsingException extends AppException {
  const DataParsingException([super.message = 'Failed to parse data.']);
}

class PlantNotFoundException extends AppException {
  const PlantNotFoundException([
    super.message = 'No se encontro la planta solicitada.',
  ]);
}
