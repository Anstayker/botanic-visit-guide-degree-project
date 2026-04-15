import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../plant_progress/domain/usecases/discover_plant.dart'
    as plant_progress;
import '../../domain/usecases/validate_qr_code.dart';

part 'qr_scanner_state.dart';

class QRScannerCubit extends Cubit<QrScannerState> {
  final ValidateQrCode validateQrCode;
  final plant_progress.DiscoverPlant discoverPlant;

  QRScannerCubit({required this.validateQrCode, required this.discoverPlant})
    : super(const QrScannerState());

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
      (_) => emit(
        state.copyWith(
          status: QrScannerStatus.success,
          message: 'Planta desbloqueada correctamente.',
          discoveredPlantId: plantId,
          isProcessing: false,
        ),
      ),
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
