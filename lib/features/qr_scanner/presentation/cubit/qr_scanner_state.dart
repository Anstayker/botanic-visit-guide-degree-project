part of 'qr_scanner_cubit.dart';

enum QrScannerStatus { initial, validating, success, error }

class QrScannerState extends Equatable {
  final QrScannerStatus status;
  final String? message;
  final String? scannedValue;
  final String? discoveredPlantId;
  final bool isProcessing;

  const QrScannerState({
    this.status = QrScannerStatus.initial,
    this.message,
    this.scannedValue,
    this.discoveredPlantId,
    this.isProcessing = false,
  });

  QrScannerState copyWith({
    QrScannerStatus? status,
    String? message,
    String? scannedValue,
    String? discoveredPlantId,
    bool? isProcessing,
  }) {
    return QrScannerState(
      status: status ?? this.status,
      message: message,
      scannedValue: scannedValue ?? this.scannedValue,
      discoveredPlantId: discoveredPlantId ?? this.discoveredPlantId,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }

  @override
  List<Object?> get props => [
    status,
    message,
    scannedValue,
    discoveredPlantId,
    isProcessing,
  ];
}
