import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../injection_container.dart';
import '../cubit/qr_scanner_cubit.dart';

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
          appBar: AppBar(title: const Text('Escaner QR')),
          body: Stack(
            fit: StackFit.expand,
            children: [
              MobileScanner(
                controller: _cameraController,
                onDetect: (capture) {
                  final barcode = capture.barcodes.firstWhere(
                    (value) =>
                        value.rawValue != null && value.rawValue!.isNotEmpty,
                    orElse: () => const Barcode(rawValue: null),
                  );

                  final rawValue = barcode.rawValue;
                  if (rawValue == null || rawValue.isEmpty) {
                    return;
                  }

                  context.read<QRScannerCubit>().onQrDetected(rawValue);
                },
              ),
              const _ScannerOverlay(),
              Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  minimum: const EdgeInsets.all(16),
                  child: BlocBuilder<QRScannerCubit, QrScannerState>(
                    builder: (context, state) {
                      final isSuccess = state.status == QrScannerStatus.success;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (state.status == QrScannerStatus.validating)
                            const _StatusBanner(
                              icon: Icons.hourglass_bottom,
                              title: 'Validando QR',
                              subtitle: 'Comprobando el codigo escaneado.',
                            )
                          else if (isSuccess)
                            _StatusBanner(
                              icon: Icons.verified,
                              title: 'Planta desbloqueada',
                              subtitle: state.message ?? '',
                            )
                          else
                            const _StatusBanner(
                              icon: Icons.qr_code_scanner,
                              title: 'Apunta al QR',
                              subtitle:
                                  'Coloca el codigo dentro del marco para desbloquear la planta.',
                            ),
                          const SizedBox(height: 12),
                          if (isSuccess)
                            FilledButton.icon(
                              onPressed: () async {
                                await context.read<QRScannerCubit>().reset();
                                await _cameraController.start();
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Escanear otro QR'),
                            )
                          else
                            FilledButton.icon(
                              onPressed: () async {
                                await _cameraController.start();
                              },
                              icon: const Icon(Icons.camera_alt_outlined),
                              label: const Text('Reanudar camara'),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScannerOverlay extends StatelessWidget {
  const _ScannerOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.25),
              Colors.transparent,
              Colors.black.withValues(alpha: 0.35),
            ],
            stops: const [0.0, 0.45, 1.0],
          ),
        ),
        child: Center(
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 24,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Stack(
              children: const [
                Positioned(
                  top: 16,
                  left: 16,
                  child: _CornerMarker(alignment: Alignment.topLeft),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: _CornerMarker(alignment: Alignment.topRight),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: _CornerMarker(alignment: Alignment.bottomLeft),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: _CornerMarker(alignment: Alignment.bottomRight),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CornerMarker extends StatelessWidget {
  const _CornerMarker({required this.alignment});

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: alignment.y < 0
                ? const BorderSide(color: Colors.white, width: 4)
                : BorderSide.none,
            bottom: alignment.y > 0
                ? const BorderSide(color: Colors.white, width: 4)
                : BorderSide.none,
            left: alignment.x < 0
                ? const BorderSide(color: Colors.white, width: 4)
                : BorderSide.none,
            right: alignment.x > 0
                ? const BorderSide(color: Colors.white, width: 4)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
