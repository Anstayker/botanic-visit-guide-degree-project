import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/entities/plant.dart';
import '../../../../injection_container.dart';
import '../../domain/usecases/get_plant_details_data.dart';
import '../cubit/plant_details_cubit.dart';
import '../widgets/plant_details_widgets.dart';

class PlantDetailsPage extends StatelessWidget {
  const PlantDetailsPage({super.key, required this.plantId});

  final String? plantId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PlantDetailsCubit(getPlantDetailsData: sl<GetPlantDetailsData>())
            ..fetchPlantDetailsData(plantId ?? ''),
      child: PlantDetailsView(plantId: plantId ?? ''),
    );
  }
}

class PlantDetailsView extends StatelessWidget {
  final String plantId;

  const PlantDetailsView({super.key, required this.plantId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          if (plantId.isNotEmpty) PlantHeroAppBar(plantId: plantId),
          BlocBuilder<PlantDetailsCubit, PlantDetailsState>(
            builder: (context, state) {
              if (state is PlantDetailsError) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('Error: ${state.message}')),
                );
              }

              if (state is PlantDetailsLoaded) {
                final plant = state.plantDetails;
                return SliverMainAxisGroup(
                  slivers: [
                    if (plantId.isEmpty)
                      PlantHeroAppBar(plantId: state.plantDetails.id),
                    PlantDetailsBody(theme: theme, plant: plant),
                  ],
                );
              }

              return const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ],
      ),
    );
  }
}

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
              PlantBioDataGrid(theme: theme),
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
              const SizedBox(height: 24),
              Text(
                'Cuidados',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Luz: Dolore adipisicing enim tempor non id elit est proident anim magna sint officia sunt ea. Nisi duis sunt consectetur est consequat elit ipsum labore deserunt id esse veniam sit sint. Incididunt mollit quis consectetur voluptate.\n'
                'Riego: Consequat deserunt eiusmod nisi aute. Voluptate do occaecat in fugiat tempor. Id voluptate do voluptate cillum deserunt. Cupidatat aliquip commodo dolore incididunt elit excepteur tempor anim commodo quis cupidatat. Tempor culpa Lorem id anim nulla duis commodo labore ut culpa.\n'
                'Sustrato: Eiusmod anim excepteur anim enim nulla. Adipisicing mollit occaecat esse cupidatat quis ipsum irure veniam reprehenderit. Eiusmod esse nisi quis nostrud nisi quis dolor eu sit. Anim cillum sit deserunt nulla.',
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
