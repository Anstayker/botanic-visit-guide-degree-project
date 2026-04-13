import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/entities/plant.dart';
import '../bloc/encyclopedia_bloc.dart';

class EncyPlantGridWidget extends StatelessWidget {
  const EncyPlantGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EncyclopediaBloc, EncyclopediaState>(
      builder: (context, state) {
        if (state is EncyclopediaLoaded) {
          return EncyclopediaPlantGrid(
            plants: state.plants,
            onPlantTap: (plant) {
              Navigator.of(context).pushNamed(
                AppRoutes.plantDetails,
                arguments: {'plantId': plant.id, 'imageUrl': plant.image},
              );
            },
          );
        }
        if (state is EncyclopediaLoading) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is EncyclopediaError) {
          return SliverToBoxAdapter(
            child: Center(child: Text('Error: ${state.message}')),
          );
        }

        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}

class EncyclopediaPlantGrid extends StatelessWidget {
  final List<Plant> plants;
  final Function(Plant) onPlantTap;

  const EncyclopediaPlantGrid({
    super.key,
    required this.plants,
    required this.onPlantTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.0,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final plant = plants[index];
          return EncyclopediaGridItem(
            plant: plant,
            onTap: () => onPlantTap(plant),
          );
        }, childCount: plants.length),
      ),
    );
  }
}

class EncyclopediaGridItem extends StatelessWidget {
  final Plant plant;
  final VoidCallback onTap;

  const EncyclopediaGridItem({
    super.key,
    required this.plant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(16.0),
      child: Stack(
        children: [
          //* Background image or placeholder
          Positioned.fill(
            child: plant.image.isNotEmpty
                ? Hero(
                    tag: 'plant_image_${plant.id}',
                    child: _PlantGridAssetImage(
                      imagePath: plant.image,
                      isLocked: !plant.isDiscovered,
                    ),
                  )
                : const _PlantGridMissingImagePlaceholder(),
          ),

          //* Black gradient overlay for better text visibility
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.6, 1.0],
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),
          ),

          //* Plant name at the bottom
          Positioned(
            left: 8,
            right: 8,
            bottom: 8,
            child: Text(
              plant.isDiscovered ? plant.name : '???',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: plant.isDiscovered ? Colors.white : Colors.white60,
                fontWeight: plant.isDiscovered
                    ? FontWeight.bold
                    : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ),

          //* InkWell for tap effect
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                // TODO: Change onTap behavior if plant is not discovered (e.g., show a tooltip or do nothing)
                onTap: plant.isDiscovered ? onTap : () => {onTap()},
                splashColor: Colors.white.withValues(alpha: 0.3),
                highlightColor: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlantGridAssetImage extends StatelessWidget {
  const _PlantGridAssetImage({required this.imagePath, required this.isLocked});

  final String imagePath;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    final imageWidget = Image.asset(
      imagePath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const _PlantGridMissingImagePlaceholder();
      },
    );

    if (!isLocked) {
      return imageWidget;
    }

    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(<double>[
        0.49,
        0.41,
        0.10,
        0,
        10,
        0.49,
        0.41,
        0.10,
        0,
        10,
        0.49,
        0.41,
        0.10,
        0,
        10,
        0,
        0,
        0,
        1,
        0,
      ]),
      child: imageWidget,
    );
  }
}

class _PlantGridMissingImagePlaceholder extends StatelessWidget {
  const _PlantGridMissingImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      alignment: Alignment.center,
      child: const Icon(Icons.local_florist, size: 48, color: Colors.white70),
    );
  }
}
