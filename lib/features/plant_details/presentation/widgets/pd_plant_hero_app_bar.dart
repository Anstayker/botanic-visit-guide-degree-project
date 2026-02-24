import 'package:flutter/material.dart';

class PlantHeroAppBar extends StatelessWidget {
  final String plantId;
  // TODO: Need the image String argument

  const PlantHeroAppBar({required this.plantId, super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SliverAppBar(
      expandedHeight: screenHeight * 0.45,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.black.withValues(alpha: 0.4),
          child: BackButton(color: Colors.white),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: [StretchMode.zoomBackground],
        background: Hero(
          tag: 'plant_image_$plantId',
          child: Image.asset(
            //TODO: Replace with actual plant image when available
            'assets/images/plants/Azucena_blanca_2.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.shade300,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.local_florist,
                  size: 72,
                  color: Colors.white70,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
