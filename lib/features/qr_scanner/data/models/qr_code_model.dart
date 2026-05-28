import 'package:equatable/equatable.dart';

class QrCodeModel extends Equatable {
  const QrCodeModel({required this.rawValue, required this.plantId});

  final String rawValue;
  final String plantId;

  factory QrCodeModel.fromRawValue(String rawValue) {
    final normalizedValue = rawValue.trim();
    final plantId = _extractPlantId(normalizedValue);

    if (plantId == null || plantId.isEmpty) {
      throw const FormatException('El QR escaneado no es valido.');
    }

    return QrCodeModel(rawValue: normalizedValue, plantId: plantId);
  }

  static String? _extractPlantId(String rawValue) {
    if (rawValue.isEmpty) {
      return null;
    }

    if (_isLikelyPlantId(rawValue)) {
      return rawValue;
    }

    final uri = Uri.tryParse(rawValue);
    if (uri != null) {
      final plantIdFromQuery =
          uri.queryParameters['plantId'] ?? uri.queryParameters['id'];
      if (plantIdFromQuery != null && plantIdFromQuery.isNotEmpty) {
        return plantIdFromQuery;
      }

      if (uri.pathSegments.isNotEmpty) {
        final lastSegment = uri.pathSegments.last;
        if (_isLikelyPlantId(lastSegment)) {
          return lastSegment;
        }
      }
    }

    if (rawValue.contains(':')) {
      final candidate = rawValue.split(':').last.trim();
      if (_isLikelyPlantId(candidate)) {
        return candidate;
      }
    }

    return null;
  }

  static bool _isLikelyPlantId(String value) {
    final normalized = value.trim();
    return normalized.isNotEmpty && !normalized.contains(RegExp(r'\s'));
  }

  @override
  List<Object?> get props => [rawValue, plantId];
}
