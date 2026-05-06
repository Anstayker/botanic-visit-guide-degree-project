import 'package:flutter/material.dart';

import '../../domain/entities/exploration_plant.dart';

class ExplorationPlantDetectedDialog extends StatelessWidget {
  static const double _approxDistanceThresholdMeters = 9;

  const ExplorationPlantDetectedDialog({
    super.key,
    required this.explorationPlant,
    required this.onViewDetails,
  });

  final ExplorationPlant explorationPlant;
  final VoidCallback onViewDetails;

  static Future<void> show(
    BuildContext context,
    ExplorationPlant explorationPlant, {
    required VoidCallback onViewDetails,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => ExplorationPlantDetectedDialog(
        explorationPlant: explorationPlant,
        onViewDetails: onViewDetails,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final plant = explorationPlant.plant;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Center(
        child: Text(
          '¡Planta descubierta!',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.brown.shade700,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Plant image
          if (plant.image.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                plant.image,
                width: 180,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 180,
                  height: 120,
                  color: colorScheme.surfaceContainerHighest,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.local_florist,
                    size: 48,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            )
          else
            Container(
              width: 180,
              height: 120,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.local_florist,
                size: 48,
                color: colorScheme.primary,
              ),
            ),
          const SizedBox(height: 8),
          Text(
            plant.name,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          if (plant.scientificName.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              plant.scientificName,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 4),
          // compact info rows
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CompactInfo(
                icon: Icons.straighten,
                label: _distanceLabel(explorationPlant.distance),
              ),
              const SizedBox(width: 12),
              _CompactInfo(
                icon: Icons.explore,
                label: _bearingToDirection(explorationPlant.bearing),
              ),
            ],
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      actions: [
        SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.onSurface,
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Seguir explorando'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onViewDetails();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.menu_book_outlined),
                        SizedBox(width: 10),
                        Text('Ver detalles'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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

  String _distanceLabel(double distanceMeters) {
    final rounded = distanceMeters.toStringAsFixed(0);
    if (distanceMeters <= _approxDistanceThresholdMeters) {
      return '~${rounded}m';
    }
    return '${rounded}m';
  }
}

class _CompactInfo extends StatelessWidget {
  const _CompactInfo({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
