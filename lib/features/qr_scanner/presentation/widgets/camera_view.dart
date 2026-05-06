import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

typedef QrDetectedCallback = void Function(String rawValue);

class CameraView extends StatelessWidget {
  const CameraView({
    super.key,
    required this.controller,
    required this.onQrDetected,
  });

  final MobileScannerController controller;
  final QrDetectedCallback onQrDetected;

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: controller,
      onDetect: (capture) {
        final barcode = capture.barcodes.firstWhere(
          (value) => value.rawValue != null && value.rawValue!.isNotEmpty,
          orElse: () => const Barcode(rawValue: null),
        );

        final rawValue = barcode.rawValue;
        if (rawValue == null || rawValue.isEmpty) return;

        onQrDetected(rawValue);
      },
    );
  }
}
