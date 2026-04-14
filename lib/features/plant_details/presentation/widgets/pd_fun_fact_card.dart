import 'package:flutter/material.dart';

class PlantFunFactCard extends StatelessWidget {
  const PlantFunFactCard({super.key, required this.theme, this.text});

  final ThemeData theme;
  final String? text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline, color: colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text ??
                  'Dato curioso: Esta planta es muy apreciada en jardines botanicos por su valor ornamental y adaptacion al clima local.',
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
