import 'package:flutter/material.dart';

import '../../../../core/entities/plant.dart';

class PlantBioDataGrid extends StatelessWidget {
  const PlantBioDataGrid({super.key, required this.theme, required this.plant});

  final ThemeData theme;
  final Plant plant;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cuidados basicos',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          padding: EdgeInsets.zero,
          primary: false,
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.8,
          children: [
            _buildStatCard(
              theme,
              icon: Icons.water_drop,
              title: 'Riego',
              value: plant.watering,
            ),
            _buildStatCard(
              theme,
              icon: Icons.wb_sunny_outlined,
              title: 'Iluminacion',
              value: plant.illumination,
            ),
            _buildStatCard(
              theme,
              icon: Icons.thermostat,
              title: 'Temperatura Min',
              value: '${plant.minTemperature} °C',
            ),
            _buildStatCard(
              theme,
              icon: Icons.device_thermostat,
              title: 'Temperatura Max',
              value: '${plant.maxTemperature} °C',
            ),
          ],
        ),
      ],
    );
  }

  Container _buildStatCard(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.labelMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
