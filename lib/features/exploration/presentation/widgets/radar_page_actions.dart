import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/exploration_bloc.dart';

class RadarPageActions extends StatelessWidget {
  const RadarPageActions({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: BlocBuilder<ExplorationBloc, ExplorationState>(
            builder: (context, state) {
              final isScanning = state.isSonarActive;

              return FilledButton.icon(
                onPressed: isScanning
                    ? null
                    : () {
                        context.read<ExplorationBloc>().add(
                          ExplorationSonnarTriggered(),
                        );
                      },
                icon: Icon(isScanning ? Icons.animation : Icons.sensors),
                label: Text(
                  isScanning ? 'Escaneando...' : 'Escanear Alrededores',
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 16,
                  ),
                  textStyle: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  shape: const StadiumBorder(),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
          child: BlocBuilder<ExplorationBloc, ExplorationState>(
            builder: (context, state) {
              return SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Rotar con brújula'),
                subtitle: const Text(
                  'Desactívala para mantener la referencia fija del radar.',
                ),
                value: state.isHeadingRotationEnabled,
                onChanged: (value) {
                  context.read<ExplorationBloc>().add(
                    ExplorationRotationPreferenceToggled(enabled: value),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
