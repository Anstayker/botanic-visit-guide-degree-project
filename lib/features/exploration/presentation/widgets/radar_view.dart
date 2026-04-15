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
  static const double _maxRadarDistance = 60;
  static const double _radarVisibleRadiusFactor = 0.56;
  static const double _approxDistanceThresholdMeters = 9;
  static const double _visionConeHalfAngleDegrees = 28;
  static const double _visionConeLengthFactor = 0.96;

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
    final colorScheme = Theme.of(context).colorScheme;

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
              final radarRadius = size * _radarVisibleRadiusFactor;
              final center = Offset(
                constraints.maxWidth / 2,
                constraints.maxHeight / 2,
              );

              return Stack(
                children: [
                  Center(
                    child: CustomPaint(
                      size: Size.square(size * 0.85),
                      painter: _RadarRingsPainter(
                        ringColor: colorScheme.primary.withValues(alpha: 0.35),
                      ),
                    ),
                  ),
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
                  Center(
                    child: Transform.rotate(
                      angle: state.isHeadingRotationEnabled
                          ? (state.userPosition?.heading ?? 0) * math.pi / 180
                          : 0,
                      child: Container(
                        width: 36,
                        height: 36,
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
                          Icons.person,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  if (!state.isHeadingRotationEnabled &&
                      state.userPosition != null)
                    Center(
                      child: _HeadingConeIndicator(
                        headingDegrees: state.userPosition!.heading,
                        color: colorScheme.primary,
                        coneHalfAngleDegrees: _visionConeHalfAngleDegrees,
                        coneLengthFactor: _visionConeLengthFactor,
                      ),
                    ),
                  for (final plant in state.plants.where(
                    (p) => p.isVisibleInRadar && p.distance > 0,
                  ))
                    _buildPlantMarker(
                      plant: plant,
                      state: state,
                      center: center,
                      radarRadius: radarRadius,
                      color: colorScheme.primary,
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
    required ExplorationPlant plant,
    required ExplorationState state,
    required Offset center,
    required double radarRadius,
    required Color color,
  }) {
    final angle =
        _plotBearingDegrees(plant: plant, state: state) * math.pi / 180;
    final normalizedDistance = (plant.distance / _maxRadarDistance).clamp(
      0.0,
      1.0,
    );
    final markerOffset = Offset(
      center.dx + math.sin(angle) * radarRadius * normalizedDistance,
      center.dy - math.cos(angle) * radarRadius * normalizedDistance,
    );

    return Positioned(
      left: markerOffset.dx - 18,
      top: markerOffset.dy - 18,
      child: _PlantMarker(
        plant: plant,
        color: color,
        distanceLabel: _distanceLabel(plant.distance),
      ),
    );
  }

  double _plotBearingDegrees({
    required ExplorationPlant plant,
    required ExplorationState state,
  }) {
    if (state.isHeadingRotationEnabled) {
      return plant.bearing;
    }

    final heading = state.userPosition?.heading ?? 0;
    return _normalizeBearing(plant.bearing + heading);
  }

  double _normalizeBearing(double value) {
    return (value % 360 + 360) % 360;
  }

  String _distanceLabel(double distanceMeters) {
    final rounded = distanceMeters.toStringAsFixed(0);
    if (distanceMeters <= _approxDistanceThresholdMeters) {
      return '~${rounded}m';
    }
    return '${rounded}m';
  }
}

class _HeadingConeIndicator extends StatelessWidget {
  const _HeadingConeIndicator({
    required this.headingDegrees,
    required this.color,
    required this.coneHalfAngleDegrees,
    required this.coneLengthFactor,
  });

  final double headingDegrees;
  final Color color;
  final double coneHalfAngleDegrees;
  final double coneLengthFactor;

  @override
  Widget build(BuildContext context) {
    final headingRadians = headingDegrees * math.pi / 180;
    final coneHalfAngleRadians = coneHalfAngleDegrees * math.pi / 180;

    return SizedBox.square(
      dimension: 150,
      child: CustomPaint(
        painter: _HeadingConePainter(
          headingRadians: headingRadians,
          coneHalfAngleRadians: coneHalfAngleRadians,
          color: color,
          coneLengthFactor: coneLengthFactor,
        ),
      ),
    );
  }
}

class _HeadingConePainter extends CustomPainter {
  _HeadingConePainter({
    required this.headingRadians,
    required this.coneHalfAngleRadians,
    required this.color,
    required this.coneLengthFactor,
  });

  final double headingRadians;
  final double coneHalfAngleRadians;
  final Color color;
  final double coneLengthFactor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxRadius = size.shortestSide * coneLengthFactor / 2;
    final innerRadius = size.shortestSide * 0.12;

    final outerLeft = Offset(
      center.dx + math.sin(-coneHalfAngleRadians) * maxRadius,
      center.dy - math.cos(-coneHalfAngleRadians) * maxRadius,
    );
    final outerRight = Offset(
      center.dx + math.sin(coneHalfAngleRadians) * maxRadius,
      center.dy - math.cos(coneHalfAngleRadians) * maxRadius,
    );
    final innerLeft = Offset(
      center.dx + math.sin(-coneHalfAngleRadians) * innerRadius,
      center.dy - math.cos(-coneHalfAngleRadians) * innerRadius,
    );
    final innerRight = Offset(
      center.dx + math.sin(coneHalfAngleRadians) * innerRadius,
      center.dy - math.cos(coneHalfAngleRadians) * innerRadius,
    );

    final path = Path()
      ..moveTo(innerLeft.dx, innerLeft.dy)
      ..lineTo(outerLeft.dx, outerLeft.dy)
      ..arcTo(
        Rect.fromCircle(center: center, radius: maxRadius),
        -math.pi / 2 - coneHalfAngleRadians,
        coneHalfAngleRadians * 2,
        false,
      )
      ..lineTo(innerRight.dx, innerRight.dy)
      ..arcTo(
        Rect.fromCircle(center: center, radius: innerRadius),
        -math.pi / 2 + coneHalfAngleRadians,
        -coneHalfAngleRadians * 2,
        false,
      )
      ..close();

    final shader = RadialGradient(
      colors: [
        color.withValues(alpha: 0.30),
        color.withValues(alpha: 0.10),
        Colors.transparent,
      ],
      stops: const [0.0, 0.45, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: maxRadius));

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(headingRadians);
    canvas.translate(-center.dx, -center.dy);

    final paint = Paint()
      ..shader = shader
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);

    final edgePaint = Paint()
      ..color = color.withValues(alpha: 0.28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;
    canvas.drawPath(path, edgePaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _HeadingConePainter oldDelegate) {
    return oldDelegate.headingRadians != headingRadians ||
        oldDelegate.coneHalfAngleRadians != coneHalfAngleRadians ||
        oldDelegate.color != color ||
        oldDelegate.coneLengthFactor != coneLengthFactor;
  }
}

class _PlantMarker extends StatelessWidget {
  const _PlantMarker({
    required this.plant,
    required this.color,
    required this.distanceLabel,
  });

  final ExplorationPlant plant;
  final Color color;
  final String distanceLabel;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '${plant.plant.name} ($distanceLabel)',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: plant.plant.isDiscovered
                  ? color.withValues(alpha: 0.3)
                  : color.withValues(alpha: 0.2),
              border: Border.all(
                color: plant.plant.isDiscovered
                    ? color.withValues(alpha: 0.9)
                    : color.withValues(alpha: 0.7),
                width: plant.plant.isDiscovered ? 1.6 : 1.0,
              ),
            ),
            child: Icon(Icons.local_florist, color: color, size: 18),
          ),
          const SizedBox(height: 4),
          Text(
            '${plant.plant.name}'
            '\n$distanceLabel',
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
