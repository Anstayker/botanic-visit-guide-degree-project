import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/entities/plant.dart';
import '../../../plant_details/domain/usecases/get_plant_details_data.dart'
    show GetPlantDetailsData;
import '../../../plant_details/domain/usecases/get_plant_details_data.dart'
    as plant_details_params
    show Params;
import '../../../plant_progress/domain/usecases/discover_plant.dart'
    as plant_progress;
import '../../domain/usecases/validate_qr_code.dart';

part 'qr_scanner_state.dart';

class QRScannerCubit extends Cubit<QrScannerState> {
  final ValidateQrCode validateQrCode;
  final plant_progress.DiscoverPlant discoverPlant;
  final GetPlantDetailsData getPlantDetailsData;

  QRScannerCubit({
    required this.validateQrCode,
    required this.discoverPlant,
    required this.getPlantDetailsData,
  }) : super(const QrScannerState());

  Future<void> reset() async {
    emit(const QrScannerState());
  }

  Future<void> onQrDetected(String rawValue) async {
    if (state.isProcessing) {
      return;
    }

    emit(
      state.copyWith(
        status: QrScannerStatus.validating,
        message: null,
        scannedValue: rawValue,
        isProcessing: true,
      ),
    );

    final validationResult = await validateQrCode(Params(rawValue: rawValue));

    final plantId = validationResult.fold<String?>((failure) {
      emit(
        state.copyWith(
          status: QrScannerStatus.error,
          message: failure.message,
          isProcessing: false,
        ),
      );
      return null;
    }, (value) => value);

    if (plantId == null) {
      return;
    }

    final unlockResult = await discoverPlant(
      plant_progress.Params(plantId: plantId),
    );

    unlockResult.fold(
      (failure) => emit(
        state.copyWith(
          status: QrScannerStatus.error,
          message: failure.message,
          isProcessing: false,
        ),
      ),
      (_) async {
        // Fetch plant details after successful discovery
        final plantDetailsResult = await getPlantDetailsData(
          plant_details_params.Params(id: plantId),
        );

        plantDetailsResult.fold(
          (failure) => emit(
            state.copyWith(
              status: QrScannerStatus.error,
              message: failure.message,
              isProcessing: false,
            ),
          ),
          (plant) => emit(
            state.copyWith(
              status: QrScannerStatus.success,
              message: 'Planta desbloqueada correctamente.',
              discoveredPlantId: plantId,
              discoveredPlant: plant,
              isProcessing: false,
            ),
          ),
        );
      },
    );
  }

  Future<void> onCameraUnavailable([String? message]) async {
    emit(
      state.copyWith(
        status: QrScannerStatus.error,
        message: message ?? 'No se pudo acceder a la camara.',
        isProcessing: false,
      ),
    );
  }
}
