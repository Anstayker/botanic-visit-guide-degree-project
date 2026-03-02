import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../domain/usecases/exploration_unlock_plant.dart';
import '../../domain/usecases/exploration_watch_nearby_plants.dart';
import '../bloc/exploration_bloc.dart';
import '../widgets/radar_view.dart';

class RadarPage extends StatelessWidget {
  const RadarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExplorationBloc(
        watchNearbyPlants: sl<ExplorationWatchNearbyPlants>(),
        unlockPlant: sl<ExplorationUnlockPlant>(),
      )..add(ExplorationWatchStarted()),
      child: const _RadarPageView(),
    );
  }
}

class _RadarPageView extends StatelessWidget {
  const _RadarPageView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface.withValues(alpha: 0.95),
      body: BlocListener<ExplorationBloc, ExplorationState>(
        listenWhen: (previous, current) =>
            previous.nearbyPlantDetected != current.nearbyPlantDetected &&
            current.nearbyPlantDetected != null,
        listener: (context, state) {
          showDialog(
            context: context,
            builder: (_) {
              final plant = state.nearbyPlantDetected!.plant;
              return AlertDialog(
                title: Text('Planta Detectada: ${plant.name}'),

                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cerrar'),
                  ),
                ],
              );
            },
          );
        },
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Radar Botanico',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Container(
                      color: colorScheme.surfaceTint.withValues(alpha: 0.08),
                      child: const RadarView(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                child: FilledButton.icon(
                  onPressed: () {
                    context.read<ExplorationBloc>().add(
                      ExplorationSonnarTriggered(),
                    );
                  },
                  icon: const Icon(Icons.sensors),
                  label: const Text('Escanear Alrededores'),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
