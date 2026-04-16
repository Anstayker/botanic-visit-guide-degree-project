import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/routes/app_routes.dart';
import '../../domain/entities/exploration_plant.dart';
import '../bloc/exploration_bloc.dart';
import 'exploration_plant_detected_dialog.dart';

class RadarPageActions extends StatelessWidget {
  const RadarPageActions({super.key});

  static const double _discoveryCardRangeMeters = 30;
  static const double _captureDistanceMeters = 10;
  static const double _panelHeight = 206;
  static const double _cardsViewportHeight = 132;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      child: SizedBox(
        height: _panelHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: BlocBuilder<ExplorationBloc, ExplorationState>(
              builder: (context, state) {
                final nearbyPlants = _nearbyPlants(state.plants);
                final pendingCount = nearbyPlants
                    .where((plant) => !plant.plant.isDiscovered)
                    .length;
                final discoveredCount = nearbyPlants.length - pendingCount;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Posible descubrimiento',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        _CounterChip(
                          icon: Icons.help_outline,
                          count: pendingCount,
                          color: colorScheme.primary,
                        ),
                        if (discoveredCount > 0) ...[
                          const SizedBox(width: 8),
                          _CounterChip(
                            icon: Icons.check_circle_outline,
                            count: discoveredCount,
                            color: Colors.green.shade700,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: SizedBox(
                        height: _cardsViewportHeight,
                        width: double.infinity,
                        child: nearbyPlants.isEmpty
                            ? Center(
                                child: Text(
                                  'Camina para explorar el entorno',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: nearbyPlants.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(width: 10),
                                itemBuilder: (context, index) {
                                  final plant = nearbyPlants[index];
                                  final isDiscovered = plant.plant.isDiscovered;

                                  return _NearbyPlantCard(
                                    width:
                                        MediaQuery.of(context).size.width *
                                        0.66,
                                    plant: plant,
                                    isDiscovered: isDiscovered,
                                    canCapture:
                                        !isDiscovered &&
                                        plant.distance <=
                                            _captureDistanceMeters,
                                    onCapture: () {
                                      context.read<ExplorationBloc>().add(
                                        ExplorationCaptureRequested(
                                          plantId: plant.plant.id,
                                        ),
                                      );
                                    },
                                    onDiscoveredPressed: () {
                                      ExplorationPlantDetectedDialog.show(
                                        context,
                                        plant,
                                        onViewDetails: () {
                                          Navigator.of(context).pushNamed(
                                            AppRoutes.plantDetails,
                                            arguments: {
                                              'plantId': plant.plant.id,
                                              'imageUrl': plant.plant.image,
                                            },
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  List<ExplorationPlant> _nearbyPlants(List<ExplorationPlant> plants) {
    final candidates = <ExplorationPlant>[];

    for (final plant in plants) {
      final isCandidate =
          plant.isVisibleInRadar && plant.distance <= _discoveryCardRangeMeters;
      if (isCandidate) {
        candidates.add(plant);
      }
    }

    candidates.sort((a, b) {
      final aPending = !a.plant.isDiscovered;
      final bPending = !b.plant.isDiscovered;
      if (aPending != bPending) {
        return aPending ? -1 : 1;
      }
      return a.distance.compareTo(b.distance);
    });

    return candidates;
  }
}

class _CounterChip extends StatelessWidget {
  const _CounterChip({
    required this.icon,
    required this.count,
    required this.color,
  });

  final IconData icon;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            '$count',
            style: theme.textTheme.labelLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _NearbyPlantCard extends StatelessWidget {
  const _NearbyPlantCard({
    required this.width,
    required this.plant,
    required this.isDiscovered,
    required this.canCapture,
    required this.onCapture,
    required this.onDiscoveredPressed,
  });

  final double width;
  final ExplorationPlant plant;
  final bool isDiscovered;
  final bool canCapture;
  final VoidCallback onCapture;
  final VoidCallback onDiscoveredPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final roundedDistance = plant.distance.toStringAsFixed(0);

    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 64,
                height: 64,
                child: Image.asset(
                  plant.plant.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: colorScheme.surfaceContainerHighest,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.local_florist,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    plant.plant.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$roundedDistance m',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: isDiscovered
                        ? OutlinedButton(
                            onPressed: onDiscoveredPressed,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.green.shade700),
                              foregroundColor: Colors.green.shade700,
                              minimumSize: const Size.fromHeight(36),
                            ),
                            child: const Text('Ya encontrada'),
                          )
                        : FilledButton(
                            onPressed: canCapture ? onCapture : null,
                            style: FilledButton.styleFrom(
                              backgroundColor: canCapture
                                  ? colorScheme.primary
                                  : colorScheme.surfaceContainerHighest,
                              foregroundColor: canCapture
                                  ? colorScheme.onPrimary
                                  : colorScheme.onSurfaceVariant,
                              disabledBackgroundColor:
                                  colorScheme.surfaceContainerHighest,
                              disabledForegroundColor:
                                  colorScheme.onSurfaceVariant,
                              minimumSize: const Size.fromHeight(36),
                            ),
                            child: Text(canCapture ? 'Capturar' : 'Muy lejos'),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
