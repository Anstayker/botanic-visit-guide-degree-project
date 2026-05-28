import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../injection_container.dart';
import '../../../plant_details/domain/usecases/get_plant_details_data.dart';
import '../cubit/qr_scanner_cubit.dart';
import '../widgets/camera_view.dart';
import '../widgets/qr_error_dialog.dart';
import '../widgets/qr_plant_discovered_dialog.dart';
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
      create: (_) => QRScannerCubit(
        validateQrCode: sl(),
        discoverPlant: sl(),
        getPlantDetailsData: sl<GetPlantDetailsData>(),
      ),
      child: BlocListener<QRScannerCubit, QrScannerState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == QrScannerStatus.success &&
              state.discoveredPlant != null) {
            _handlePlantDiscovered(context, state);
          }

          if (state.status == QrScannerStatus.error && state.message != null) {
            _handleQrError(context, state);
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

  Future<void> _handlePlantDiscovered(
    BuildContext context,
    QrScannerState state,
  ) async {
    await _cameraController.stop();
    if (!context.mounted) {
      return;
    }

    await QrPlantDiscoveredDialog.show(
      context,
      state.discoveredPlant!,
      onViewDetails: () {
        if (context.mounted) {
          Navigator.of(
            context,
          ).pushNamed('/plant-details', arguments: state.discoveredPlantId);
        }
      },
    );

    if (context.mounted) {
      await _cameraController.start();
    }
  }

  Future<void> _handleQrError(
    BuildContext context,
    QrScannerState state,
  ) async {
    final cubit = context.read<QRScannerCubit>();

    await QrErrorDialog.show(
      context,
      state.message!,
      onRetry: () async {
        if (context.mounted) {
          await cubit.reset();
          await _cameraController.start();
        }
      },
    );
  }
}
