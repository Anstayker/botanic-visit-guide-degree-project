import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/entities/exploration_map_region.dart';
import '../bloc/exploration_bloc.dart';

class ExplorationMapView extends StatefulWidget {
  const ExplorationMapView({super.key});

  @override
  State<ExplorationMapView> createState() => _ExplorationMapViewState();
}

class _ExplorationMapViewState extends State<ExplorationMapView> {
  static const String _tileUrlTemplate =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  final Map<int, NetworkTileProvider> _tileProvidersBySize = {};

  NetworkTileProvider _tileProviderFor(int maxCacheSizeBytes) {
    return _tileProvidersBySize.putIfAbsent(
      maxCacheSizeBytes,
      () => NetworkTileProvider(
        silenceExceptions: true,
        cachingProvider: BuiltInMapCachingProvider.getOrCreateInstance(
          maxCacheSize: maxCacheSizeBytes,
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (final tileProvider in _tileProvidersBySize.values) {
      unawaited(tileProvider.dispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ExplorationBloc, ExplorationState>(
      builder: (context, state) {
        final region = _pickRegion(state.mapRegions);
        final userPosition = state.userPosition;
        final tileProvider = _tileProviderFor(state.mapTileCacheMaxSizeBytes);

        final mapCenter = userPosition == null
            ? LatLng(region.centerLatitude, region.centerLongitude)
            : LatLng(userPosition.latitude, userPosition.longitude);

        return Stack(
          fit: StackFit.expand,
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: mapCenter,
                initialZoom: region.recommendedZoom,
                minZoom: region.minimumZoom,
                maxZoom: region.maximumZoom,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.none,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: _tileUrlTemplate,
                  userAgentPackageName: 'botanic_guide',
                  retinaMode: true,
                  tileProvider: tileProvider,
                  tileBuilder: (context, widget, tile) => widget,
                ),
                MarkerLayer(markers: _buildMarkers(state)),
              ],
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.10),
                      Colors.black.withValues(alpha: 0.28),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              top: 16,
              child: _MapBadge(icon: Icons.map_outlined, label: region.name),
            ),
            Positioned(
              right: 16,
              top: 16,
              child: _MapBadge(
                icon: state.isHeadingRotationEnabled
                    ? Icons.explore
                    : Icons.explore_off,
                label: state.isHeadingRotationEnabled
                    ? 'Rotación activa'
                    : 'Norte fijo',
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: _MapFooter(
                title: 'Contexto espacial',
                subtitle:
                    'La capa de mapa se apoya en datos locales y puede quedar vacía si no hay conexión o caché.',
              ),
            ),
            if (state.plants.isEmpty)
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    'Sin plantas cercanas para mostrar',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  ExplorationMapRegion _pickRegion(List<ExplorationMapRegion> regions) {
    if (regions.isNotEmpty) {
      return regions.first;
    }

    return const ExplorationMapRegion(
      id: 'fallback',
      name: 'Jardín Botánico',
      centerLatitude: -17.3866,
      centerLongitude: -66.1984,
      southWestLatitude: -17.3881,
      southWestLongitude: -66.1999,
      northEastLatitude: -17.3851,
      northEastLongitude: -66.1969,
      recommendedZoom: 18,
      minimumZoom: 16,
      maximumZoom: 20,
      shouldPrecache: true,
      priority: 100,
    );
  }

  List<Marker> _buildMarkers(ExplorationState state) {
    final markers = <Marker>[];

    final userPosition = state.userPosition;
    if (userPosition != null) {
      markers.add(
        Marker(
          point: LatLng(userPosition.latitude, userPosition.longitude),
          width: 44,
          height: 44,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.blueAccent, width: 4),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 14,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const Icon(Icons.person_pin_circle, color: Colors.blue),
          ),
        ),
      );
    }

    for (final plant in state.plants.take(12)) {
      markers.add(
        Marker(
          point: LatLng(
            plant.plant.location.latitude,
            plant.plant.location.longitude,
          ),
          width: 34,
          height: 34,
          child: Icon(
            Icons.local_florist,
            color: plant.plant.isDiscovered ? Colors.greenAccent : Colors.white,
            size: 28,
          ),
        ),
      );
    }

    return markers;
  }
}

class _MapBadge extends StatelessWidget {
  const _MapBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapFooter extends StatelessWidget {
  const _MapFooter({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
