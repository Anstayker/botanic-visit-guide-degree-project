import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../plant_details/domain/repositories/plant_details_repository.dart';

// TODO: Refactor Use Case to Clean Architecture standards, separating concerns and improving testability.

class ValidateQrCode implements Usecase<String, Params> {
  final PlantDetailsRepository repository;

  ValidateQrCode({required this.repository});

  @override
  Future<Either<Failure, String>> call(Params params) async {
    final plantId = _extractPlantId(params.rawValue);
    if (plantId == null || plantId.isEmpty) {
      return left(const InvalidQrCodeFailure());
    }

    final plantResult = await repository.getPlantDetailsData(plantId);
    return plantResult.fold(
      (failure) => left(
        failure is UnknownFailure ? const PlantNotFoundFailure() : failure,
      ),
      (_) => right(plantId),
    );
  }

  String? _extractPlantId(String rawValue) {
    final trimmedValue = rawValue.trim();
    if (trimmedValue.isEmpty) {
      return null;
    }

    if (_isLikelyPlantId(trimmedValue)) {
      return trimmedValue;
    }

    final uri = Uri.tryParse(trimmedValue);
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

    if (trimmedValue.contains(':')) {
      final candidate = trimmedValue.split(':').last.trim();
      if (_isLikelyPlantId(candidate)) {
        return candidate;
      }
    }

    return null;
  }

  bool _isLikelyPlantId(String value) {
    final normalized = value.trim();
    return normalized.isNotEmpty && !normalized.contains(RegExp(r'\s'));
  }
}

class Params extends Equatable {
  final String rawValue;

  const Params({required this.rawValue});

  @override
  List<Object?> get props => [rawValue];
}
