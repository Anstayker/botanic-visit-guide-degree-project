import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                children: [const ExplorationMapView(), const RadarView()],
              );
            },
          ),
        ),
      ),
    );
  }
}
