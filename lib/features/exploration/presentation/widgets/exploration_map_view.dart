import 'dart:async';
import 'dart:math' as math;

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

class _ExplorationMapViewState extends State<ExplorationMapView>
    with SingleTickerProviderStateMixin {
  static const String _tileUrlTemplate =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const double _mapZoomOffset = 1.4;
  static const double _minCameraMoveMeters = 1.5;
  static const Duration _rotationAnimationDuration = Duration(
    milliseconds: 240,
  );
  static const double _rotationEpsilonDegrees = 0.8;

  final Map<int, NetworkTileProvider> _tileProvidersBySize = {};
  final MapController _mapController = MapController();
  final Distance _distance = const Distance();
  late final AnimationController _rotationController;
  Animation<double>? _rotationAnimation;
  VoidCallback? _rotationTick;
  double _currentRotationDegrees = 0;
  LatLng? _lastCameraCenter;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: _rotationAnimationDuration,
    );
  }

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
    if (_rotationTick != null && _rotationAnimation != null) {
      _rotationAnimation!.removeListener(_rotationTick!);
    }
    _rotationController.dispose();
    for (final tileProvider in _tileProvidersBySize.values) {
      unawaited(tileProvider.dispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<ExplorationBloc, ExplorationState>(
      listenWhen: (previous, current) =>
          previous.userPosition != current.userPosition ||
          previous.isHeadingRotationEnabled != current.isHeadingRotationEnabled,
      listener: (context, state) {
        final userPosition = state.userPosition;
        if (userPosition == null) {
          _lastCameraCenter = null;
          _animateRotationTo(0);
          return;
        }

        final region = _pickRegion(state.mapRegions);
        final target = LatLng(userPosition.latitude, userPosition.longitude);
        final targetZoom = _effectiveZoom(region);
        final targetRotation = _targetRotationDegrees(state);

        if (!mounted) return;
        try {
          if (_shouldMoveCameraTo(target)) {
            _mapController.move(target, targetZoom);
            _lastCameraCenter = target;
          }

          _animateRotationTo(targetRotation);
        } catch (_) {
          // Ignorado: puede ocurrir antes de que el mapa termine de montarse.
        }
      },
      child: BlocBuilder<ExplorationBloc, ExplorationState>(
        builder: (context, state) {
          final region = _pickRegion(state.mapRegions);
          final userPosition = state.userPosition;
          final tileProvider = _tileProviderFor(state.mapTileCacheMaxSizeBytes);
          final zoom = _effectiveZoom(region);
          final rotation = _normalizeDegrees(_targetRotationDegrees(state));

          final mapCenter = userPosition == null
              ? LatLng(region.centerLatitude, region.centerLongitude)
              : LatLng(userPosition.latitude, userPosition.longitude);

          return Stack(
            fit: StackFit.expand,
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: mapCenter,
                  initialZoom: zoom,
                  initialRotation: rotation,
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
                ],
              ),
              Positioned(
                top: 16,
                right: 16,
                child: _CompassOverlay(
                  headingDegrees: state.userPosition?.heading,
                  isRotationEnabled: state.isHeadingRotationEnabled,
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
      ),
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

  double _effectiveZoom(ExplorationMapRegion region) {
    final zoom = region.recommendedZoom + _mapZoomOffset;
    return zoom.clamp(region.minimumZoom, region.maximumZoom).toDouble();
  }

  double _targetRotationDegrees(ExplorationState state) {
    if (!state.isHeadingRotationEnabled) {
      return 0;
    }

    // Invertimos el signo para sincronizar la rotación visual del mapa
    // con el sistema de bearings que ya usa el radar.
    return -(state.userPosition?.heading ?? 0);
  }

  void _animateRotationTo(double targetRotationDegrees) {
    final current = _normalizeDegrees(_currentRotationDegrees);
    final target = _normalizeDegrees(targetRotationDegrees);
    final shortestDelta = _shortestSignedDelta(current, target);

    if (shortestDelta.abs() < _rotationEpsilonDegrees) {
      return;
    }

    final previousAnimation = _rotationAnimation;

    _rotationAnimation =
        Tween<double>(begin: current, end: current + shortestDelta).animate(
          CurvedAnimation(
            parent: _rotationController,
            curve: Curves.easeOutCubic,
          ),
        );

    if (_rotationTick != null && previousAnimation != null) {
      previousAnimation.removeListener(_rotationTick!);
    }

    _rotationTick = () {
      final rotation = _rotationAnimation?.value;
      if (rotation == null) return;
      try {
        _mapController.rotate(_normalizeDegrees(rotation));
      } catch (_) {
        // Ignorado: puede ocurrir si el mapa aún no está montado.
      }
    };

    _rotationAnimation?.addListener(_rotationTick!);

    _rotationController
      ..stop()
      ..reset()
      ..forward();

    _currentRotationDegrees = target;
  }

  double _normalizeDegrees(double degrees) {
    return (degrees % 360 + 360) % 360;
  }

  double _shortestSignedDelta(double from, double to) {
    final diff = _normalizeDegrees(to - from);
    if (diff > 180) {
      return diff - 360;
    }
    return diff;
  }

  bool _shouldMoveCameraTo(LatLng target) {
    final previous = _lastCameraCenter;
    if (previous == null) {
      return true;
    }

    final distanceMeters = _distance.as(LengthUnit.Meter, previous, target);
    return distanceMeters >= _minCameraMoveMeters;
  }
}

class _CompassOverlay extends StatelessWidget {
  const _CompassOverlay({
    required this.headingDegrees,
    required this.isRotationEnabled,
  });

  final double? headingDegrees;
  final bool isRotationEnabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final heading = headingDegrees ?? 0.0;

    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.52),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        ),
        child: SizedBox(
          width: 64,
          height: 64,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 5,
                child: Text(
                  'N',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Positioned(
                right: 6,
                child: Text(
                  'E',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                bottom: 5,
                child: Text(
                  'S',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                left: 6,
                child: Text(
                  'W',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Transform.rotate(
                angle: -heading * math.pi / 180,
                child: Icon(
                  isRotationEnabled ? Icons.navigation : Icons.explore,
                  color: colorScheme.primaryContainer,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
