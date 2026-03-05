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
      body: MultiBlocListener(
        listeners: [
          // Listener para plantas detectadas
          BlocListener<ExplorationBloc, ExplorationState>(
            listenWhen: (previous, current) =>
                previous.nearbyPlantDetected != current.nearbyPlantDetected &&
                current.nearbyPlantDetected != null,
            listener: (context, state) {
              final explorationPlant = state.nearbyPlantDetected!;
              final plant = explorationPlant.plant;

              // showDialog(
              //   context: context,
              //   builder: (dialogContext) => AlertDialog(
              //     icon: Icon(Icons.eco, color: colorScheme.primary, size: 48),
              //     title: Text('¡Planta Detectada!'),
              //     content: Column(
              //       mainAxisSize: MainAxisSize.min,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           plant.name,
              //           style: theme.textTheme.titleLarge?.copyWith(
              //             fontWeight: FontWeight.bold,
              //             color: colorScheme.primary,
              //           ),
              //         ),
              //         const SizedBox(height: 12),
              //         _InfoRow(
              //           icon: Icons.straighten,
              //           label: 'Distancia',
              //           value:
              //               '${explorationPlant.distance.toStringAsFixed(1)}m',
              //         ),
              //         const SizedBox(height: 8),
              //         _InfoRow(
              //           icon: Icons.explore,
              //           label: 'Dirección',
              //           value: _bearingToDirection(explorationPlant.bearing),
              //         ),
              //         if (plant.scientificName.isNotEmpty) ...[
              //           const SizedBox(height: 8),
              //           _InfoRow(
              //             icon: Icons.science,
              //             label: 'Nombre científico',
              //             value: plant.scientificName,
              //           ),
              //         ],
              //       ],
              //     ),
              //     actions: [
              //       TextButton(
              //         onPressed: () => Navigator.of(dialogContext).pop(),
              //         child: const Text('Cerrar'),
              //       ),
              //       FilledButton.icon(
              //         onPressed: () {
              //           Navigator.of(dialogContext).pop();
              //           context.read<ExplorationBloc>().add(
              //             ExplorationPlantUnlockRequested(plantId: plant.id),
              //           );
              //         },
              //         icon: const Icon(Icons.lock_open),
              //         label: const Text('Desbloquear'),
              //       ),
              //     ],
              //   ),
              // );
            },
          ),
          // Listener para errores
          BlocListener<ExplorationBloc, ExplorationState>(
            listenWhen: (previous, current) =>
                current.status == ExplorationStatus.error,
            listener: (context, state) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage ?? 'Error al cargar el radar',
                  ),
                  backgroundColor: colorScheme.error,
                  action: SnackBarAction(
                    label: 'Reintentar',
                    textColor: Colors.white,
                    onPressed: () {
                      context.read<ExplorationBloc>().add(
                        ExplorationWatchStarted(),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
        child: SafeArea(
          child: Column(
            children: [
              // Barra de navegación
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
                    const Spacer(),
                    // Indicador de plantas cercanas
                    BlocBuilder<ExplorationBloc, ExplorationState>(
                      builder: (context, state) {
                        final nearbyCount = state.plants
                            .where((p) => p.isVisibleInRadar)
                            .length;

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.eco,
                                size: 16,
                                color: colorScheme.onPrimaryContainer,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$nearbyCount',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Radar
              Expanded(
                child: Padding(
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
                                  CircularProgressIndicator(
                                    color: colorScheme.primary,
                                  ),
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

                          return const RadarView();
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // Botón de escaneo
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
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
            ],
          ),
        ),
      ),
    );
  }

  String _bearingToDirection(double bearing) {
    const directions = [
      'Norte',
      'Noreste',
      'Este',
      'Sureste',
      'Sur',
      'Suroeste',
      'Oeste',
      'Noroeste',
    ];
    final index = ((bearing + 22.5) % 360 / 45).floor();
    return directions[index];
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.black54),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
