import 'package:flutter/material.dart';

class PlantGridItem {
  const PlantGridItem({
    required this.name,
    required this.isUnlocked,
    this.image,
  });

  final String name;
  final bool isUnlocked;
  final ImageProvider? image;
}

class PlantGridSliver extends StatelessWidget {
  const PlantGridSliver({
    super.key,
    required this.items,
    this.onItemTap,
    this.crossAxisCount = 3,
    this.childAspectRatio = 0.85,
  });

  final List<PlantGridItem> items;
  final void Function(PlantGridItem item, int index)? onItemTap;
  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: childAspectRatio,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final item = items[index];
          final displayName = item.isUnlocked ? item.name : '???';

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onItemTap != null ? () => onItemTap!(item, index) : null,
              borderRadius: BorderRadius.circular(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    _PlantGridImage(
                      image: item.image,
                      isLocked: !item.isUnlocked,
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.75),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (!item.isUnlocked)
                      const Center(
                        child: Icon(
                          Icons.help_outline,
                          size: 52,
                          color: Colors.white,
                        ),
                      ),
                    Positioned(
                      left: 12,
                      right: 12,
                      bottom: 12,
                      child: Text(
                        displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }, childCount: items.length),
      ),
    );
  }
}

class _PlantGridImage extends StatelessWidget {
  const _PlantGridImage({required this.image, required this.isLocked});

  final ImageProvider? image;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    final imageWidget = image != null
        ? Image(image: image!, fit: BoxFit.cover)
        : Container(
            color: Colors.grey.shade300,
            child: const Center(
              child: Icon(Icons.local_florist, size: 48, color: Colors.white70),
            ),
          );

    if (!isLocked) {
      return Positioned.fill(child: imageWidget);
    }

    return Positioned.fill(
      child: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.saturation),
        child: imageWidget,
      ),
    );
  }
}
