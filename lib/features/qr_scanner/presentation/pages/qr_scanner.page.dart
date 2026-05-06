import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../injection_container.dart';
import '../cubit/qr_scanner_cubit.dart';
import '../widgets/camera_view.dart';
import '../widgets/scanner_overlay.dart';
import '../widgets/controls_panel.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  late final MobileScannerController _cameraController;

  @override
  void initState() {
    super.initState();
    _cameraController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QRScannerCubit(validateQrCode: sl(), discoverPlant: sl()),
      child: BlocListener<QRScannerCubit, QrScannerState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) async {
          if (state.status == QrScannerStatus.success) {
            await _cameraController.stop();
            if (!context.mounted) {
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message ?? 'Planta desbloqueada.')),
            );
          }

          if (state.status == QrScannerStatus.error && state.message != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message!)));
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Escaner QR',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            actions: [
              IconButton(
                onPressed: () => _showHelpSheet(context),
                icon: const Icon(Icons.help_outline, size: 30, weight: 900),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.all(12),
                  minimumSize: const Size(36, 36),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                tooltip: 'Ayuda',
              ),
            ],
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              CameraView(
                controller: _cameraController,
                onQrDetected: (raw) =>
                    context.read<QRScannerCubit>().onQrDetected(raw),
              ),
              const ScannerOverlay(),
              ControlsPanel(controller: _cameraController),
            ],
          ),
        ),
      ),
    );
  }

  void _showHelpSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '¿Cómo funciona el escáner QR?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
