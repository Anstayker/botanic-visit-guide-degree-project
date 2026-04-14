import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../domain/usecases/get_plant_details_data.dart';
import '../cubit/plant_details_cubit.dart';
import '../widgets/plant_details_widgets.dart';

class PlantDetailsPage extends StatelessWidget {
  const PlantDetailsPage({
    super.key,
    required this.plantId,
    required this.imageUrl,
  });

  final String? plantId;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PlantDetailsCubit(getPlantDetailsData: sl<GetPlantDetailsData>())
            ..fetchPlantDetailsData(plantId ?? ''),
      child: PlantDetailsView(plantId: plantId ?? '', imageUrl: imageUrl ?? ''),
    );
  }
}

class PlantDetailsView extends StatelessWidget {
  final String plantId;
  final String imageUrl;

  const PlantDetailsView({
    super.key,
    required this.plantId,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          if (plantId.isNotEmpty)
            PlantHeroAppBar(plantId: plantId, image: imageUrl),
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
                      PlantHeroAppBar(
                        plantId: state.plantDetails.id,
                        image: state.plantDetails.image,
                      ),
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
