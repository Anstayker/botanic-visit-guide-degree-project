import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/routes/app_routes.dart';
import '../bloc/exploration_bloc.dart';
import 'exploration_plant_detected_dialog.dart';
import 'radar_page_actions.dart';
import 'radar_page_header.dart';
import 'radar_page_panel.dart';

class RadarPageBody extends StatelessWidget {
  const RadarPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface.withValues(alpha: 0.95),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ExplorationBloc, ExplorationState>(
            listenWhen: (previous, current) =>
                previous.nearbyPlantDetected?.plant.id !=
                    current.nearbyPlantDetected?.plant.id &&
                current.nearbyPlantDetected != null,
            listener: (context, state) async {
              final explorationPlant = state.nearbyPlantDetected!;

              await ExplorationPlantDetectedDialog.show(
                context,
                explorationPlant,
                onViewDetails: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.plantDetails,
                    arguments: {
                      'plantId': explorationPlant.plant.id,
                      'imageUrl': explorationPlant.plant.image,
                    },
                  );
                },
              );

              if (context.mounted) {
                context.read<ExplorationBloc>().add(
                  ExplorationNearbyPlantDetectionCleared(),
                );
              }
            },
          ),
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
            children: const [
              RadarPageHeader(),
              Expanded(child: RadarPagePanel()),
              RadarPageActions(),
            ],
          ),
        ),
      ),
    );
  }
}
