import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/exploration_plant.dart';
import '../bloc/exploration_bloc.dart';

class RadarView extends StatefulWidget {
  const RadarView({super.key});

  @override
  State<RadarView> createState() => _RadarViewState();
}

class _RadarViewState extends State<RadarView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sonarController;
  static const double _maxRadarDistance = 100;

  @override
  void initState() {
    super.initState();
    _sonarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _sonarController.dispose();
    super.dispose();
  }

  void _onSonarStateChanged(ExplorationState state) {
    if (state.isSonarActive && !_sonarController.isAnimating) {
      _sonarController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<ExplorationBloc, ExplorationState>(
      listenWhen: (previous, current) =>
          previous.isSonarActive != current.isSonarActive,
      listener: (context, state) => _onSonarStateChanged(state),
      child: BlocBuilder<ExplorationBloc, ExplorationState>(
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final size = math.min(
                constraints.maxWidth,
                constraints.maxHeight,
              );
              final radarRadius = size * 1;
              final center = Offset(
                constraints.maxWidth / 2,
                constraints.maxHeight / 2,
              );

              return Stack(
                children: [
                  // Anillos del radar
                  Center(
                    child: CustomPaint(
                      size: Size.square(size * 0.85),
                      painter: _RadarRingsPainter(
                        ringColor: colorScheme.primary.withValues(alpha: 0.35),
                      ),
                    ),
                  ),

                  // Sonar (pulso expandible)
                  if (state.isSonarActive)
                    Center(
                      child: CustomPaint(
                        size: Size.square(size * 0.85),
                        painter: _SonarPainter(
                          progress: _sonarController.value,
                          radarRadius: radarRadius,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),

                  // Icono del usuario (centro, rotando)
                  Center(
                    child: Transform.rotate(
                      angle: (state.userPosition?.heading ?? 0) * math.pi / 180,
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.primary.withValues(alpha: 0.9),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withValues(alpha: 0.4),
                              blurRadius: 18,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.navigation,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),

                  // Plantas detectadas
                  for (final plant in state.plants.where(
                    (p) => p.isVisibleInRadar && p.distance > 0,
                  ))
                    _buildPlantMarker(
                      context: context,
                      plant: plant,
                      center: center,
                      radarRadius: radarRadius,
                      colorScheme: colorScheme,
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPlantMarker({
    required BuildContext context,
    required ExplorationPlant plant,
    required Offset center,
    required double radarRadius,
    required ColorScheme colorScheme,
  }) {
    final angle = plant.bearing * math.pi / 180;
    final normalizedDistance = (plant.distance / _maxRadarDistance).clamp(
      0.0,
      1.0,
    );
    final markerOffset = Offset(
      center.dx + math.cos(angle) * radarRadius * normalizedDistance,
      center.dy + math.sin(angle) * radarRadius * normalizedDistance,
    );

    return Positioned(
      left: markerOffset.dx - 26,
      top: markerOffset.dy - 26,
      child: _PlantMarker(plant: plant, color: colorScheme.primary),
    );
  }
}

class _PlantMarker extends StatelessWidget {
  const _PlantMarker({required this.plant, required this.color});

  final ExplorationPlant plant;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '${plant.plant.name} (${plant.distance.toStringAsFixed(0)}m)',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: plant.plant.isDiscovered
                  ? color.withValues(alpha: 0.3)
                  : color.withValues(alpha: 0.2),
              border: Border.all(
                color: plant.plant.isDiscovered
                    ? color.withValues(alpha: 0.9)
                    : color.withValues(alpha: 0.7),
                width: plant.plant.isDiscovered ? 2 : 1.2,
              ),
            ),
            child: Icon(Icons.local_florist, color: color, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            '${plant.plant.name}'
            '\n${plant.distance.toStringAsFixed(0)}m',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: plant.plant.isDiscovered ? Colors.white : Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SonarPainter extends CustomPainter {
  _SonarPainter({
    required this.progress,
    required this.radarRadius,
    required this.color,
  });

  final double progress;
  final double radarRadius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);

    // Sonar expandible con desvanecimiento
    final radius = radarRadius * progress;
    final opacity = (1 - progress).clamp(0.0, 1.0);

    final paint = Paint()
      ..color = color.withValues(alpha: 0.6 * opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius, paint);

    // Círculo relleno más tenue para efecto de onda
    if (progress < 0.5) {
      final innerOpacity = (0.5 - progress) * opacity;
      final innerPaint = Paint()
        ..color = color.withValues(alpha: 0.1 * innerOpacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radius * 0.8, innerPaint);
    }
  }

  @override
  bool shouldRepaint(_SonarPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.radarRadius != radarRadius ||
        oldDelegate.color != color;
  }
}

class _RadarRingsPainter extends CustomPainter {
  _RadarRingsPainter({required this.ringColor});

  final Color ringColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final paint = Paint()
      ..color = ringColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Dibuja 4 anillos
    for (var i = 1; i <= 4; i++) {
      canvas.drawCircle(center, size.width * 0.18 * i, paint);
    }

    // Líneas de orientación (N-S y E-O)
    final linePaint = Paint()
      ..color = ringColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final maxRadius = size.width * 0.72;
    // Línea vertical (eje N-S)
    canvas.drawLine(
      Offset(center.dx, center.dy - maxRadius),
      Offset(center.dx, center.dy + maxRadius),
      linePaint,
    );
    // Línea horizontal (eje E-O)
    canvas.drawLine(
      Offset(center.dx - maxRadius, center.dy),
      Offset(center.dx + maxRadius, center.dy),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RadarRingsPainter oldDelegate) {
    return oldDelegate.ringColor != ringColor;
  }
}
