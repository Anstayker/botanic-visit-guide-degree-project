import 'package:flutter/material.dart';

import '../../../../core/entities/plant.dart';
import 'pd_fun_fact_card.dart';
import 'pd_plant_biodata_grid.dart';
import 'pd_plant_header_info.dart';

class PlantDetailsBody extends StatelessWidget {
  const PlantDetailsBody({super.key, required this.theme, required this.plant});

  final ThemeData theme;
  final Plant plant;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        transform: Matrix4.translationValues(0.0, -32.0, 0.0),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PlantHeaderInfo(plant: plant),
              const SizedBox(height: 24),
              PlantBioDataGrid(theme: theme, plant: plant),
              const SizedBox(height: 24),
              PlantFunFactCard(theme: theme, text: plant.funFact),
              const SizedBox(height: 24),
              Text(
                'Descripción',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                plant.description,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
