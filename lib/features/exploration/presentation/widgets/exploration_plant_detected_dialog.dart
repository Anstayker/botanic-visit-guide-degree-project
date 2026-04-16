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
      icon: Icon(Icons.eco, color: colorScheme.primary, size: 48),
      title: const Text('¡Planta Detectada!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            plant.name,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.straighten,
            label: 'Distancia',
            value: _distanceLabel(explorationPlant.distance),
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.explore,
            label: 'Dirección',
            value: _bearingToDirection(explorationPlant.bearing),
          ),
          if (plant.scientificName.isNotEmpty) ...[
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.science,
              label: 'Nombre científico',
              value: plant.scientificName,
            ),
          ],
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Seguir explorando'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onViewDetails();
                  },
                  icon: const Icon(Icons.menu_book),
                  label: const Text('Ver detalles'),
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

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
