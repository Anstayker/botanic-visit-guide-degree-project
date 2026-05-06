import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/routes/app_routes.dart';
import '../bloc/exploration_bloc.dart';
import 'exploration_map_view.dart';
import 'radar_view.dart';

class RadarPagePanel extends StatelessWidget {
  const RadarPagePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Container(
          color: colorScheme.surfaceTint.withValues(alpha: 0.08),
          child: BlocBuilder<ExplorationBloc, ExplorationState>(
            builder: (context, state) {
              if (state.status == ExplorationStatus.loading) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: colorScheme.primary),
                      const SizedBox(height: 16),
                      Text(
                        'Inicializando radar...',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Stack(
                fit: StackFit.expand,
                children: [
                  const ExplorationMapView(),
                  const RadarView(),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: _RadarFloatingActions(colorScheme: colorScheme),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _RadarFloatingActions extends StatelessWidget {
  const _RadarFloatingActions({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExplorationBloc, ExplorationState>(
      buildWhen: (previous, current) =>
          previous.isHeadingRotationEnabled != current.isHeadingRotationEnabled,
      builder: (context, state) {
        final rotationIcon = state.isHeadingRotationEnabled
            ? Icons.explore
            : Icons.near_me_outlined;

        return Padding(
          padding: const EdgeInsets.only(right: 4, bottom: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton.small(
                heroTag: 'radar-rotation-fab',
                backgroundColor: colorScheme.primaryContainer,
                foregroundColor: colorScheme.onPrimaryContainer,
                onPressed: () {
                  context.read<ExplorationBloc>().add(
                    ExplorationRotationPreferenceToggled(
                      enabled: !state.isHeadingRotationEnabled,
                    ),
                  );
                },
                tooltip: 'Rotar con brújula',
                child: Icon(rotationIcon),
              ),
              const SizedBox(height: 12),
              FloatingActionButton.small(
                heroTag: 'radar-camera-fab',
                backgroundColor: colorScheme.secondaryContainer,
                foregroundColor: colorScheme.onSecondaryContainer,
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.qrScanner);
                },
                tooltip: 'Cámara',
                child: const Icon(Icons.photo_camera_outlined),
              ),
            ],
          ),
        );
      },
    );
  }
}
