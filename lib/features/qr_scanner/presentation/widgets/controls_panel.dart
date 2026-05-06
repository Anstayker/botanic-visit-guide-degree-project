import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../cubit/qr_scanner_cubit.dart';
import 'status_banner.dart';

class ControlsPanel extends StatelessWidget {
  const ControlsPanel({super.key, required this.controller});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return Align(
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
                  const StatusBanner(
                    icon: Icons.hourglass_bottom,
                    title: 'Validando QR',
                    subtitle: 'Comprobando el codigo escaneado.',
                  )
                else if (isSuccess)
                  StatusBanner(
                    icon: Icons.verified,
                    title: 'Planta desbloqueada',
                    subtitle: state.message ?? '',
                  )
                else
                  const StatusBanner(
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
                      await controller.start();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Escanear otro QR'),
                  )
                else
                  FilledButton.icon(
                    onPressed: () async {
                      await controller.start();
                    },
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Reanudar camara'),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
