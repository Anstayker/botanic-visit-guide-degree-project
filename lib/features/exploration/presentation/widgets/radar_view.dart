import 'dart:math' as math;

import 'package:flutter/material.dart';

class PlantPing {
  const PlantPing({
    required this.name,
    required this.distanceMeters,
    required this.angleDegrees,
    required this.icon,
  });

  final String name;
  final double distanceMeters;
  final double angleDegrees;
  final IconData icon;
}

class RadarView extends StatefulWidget {
  const RadarView({super.key});

  @override
  State<RadarView> createState() => _RadarViewState();
}

class _RadarViewState extends State<RadarView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  final List<PlantPing> _pings = const [
    PlantPing(
      name: 'Helecho',
      distanceMeters: 28,
      angleDegrees: 35,
      icon: Icons.grass,
    ),
    PlantPing(
      name: 'Orquidea',
      distanceMeters: 62,
      angleDegrees: 160,
      icon: Icons.local_florist,
    ),
    PlantPing(
      name: 'Cactus',
      distanceMeters: 90,
      angleDegrees: 280,
      icon: Icons.spa,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(constraints.maxWidth, constraints.maxHeight);
        final radius = size * 0.36;
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
                  ringColor: colorScheme.primary.withOpacity(0.35),
                ),
              ),
            ),
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary.withOpacity(0.9),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.4),
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
            ..._pings.map((ping) {
              final angle = ping.angleDegrees * math.pi / 180;
              final normalizedDistance = (ping.distanceMeters / 100).clamp(
                0.2,
                1,
              );
              final pingOffset = Offset(
                center.dx + math.cos(angle) * radius * normalizedDistance,
                center.dy + math.sin(angle) * radius * normalizedDistance,
              );

              return Positioned(
                left: pingOffset.dx - 26,
                top: pingOffset.dy - 26,
                child: ScaleTransition(
                  scale: Tween(begin: 0.92, end: 1.05).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: Curves.easeInOut,
                    ),
                  ),
                  child: _PingBadge(ping: ping, color: colorScheme.primary),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

class _PingBadge extends StatelessWidget {
  const _PingBadge({required this.ping, required this.color});

  final PlantPing ping;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.2),
            border: Border.all(color: color.withOpacity(0.7), width: 1.2),
          ),
          child: Icon(ping.icon, color: color, size: 26),
        ),
        const SizedBox(height: 6),
        Text(
          '${ping.name} ${ping.distanceMeters.toStringAsFixed(0)}m',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
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

    for (var i = 1; i <= 3; i++) {
      canvas.drawCircle(center, size.width * 0.18 * i, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarRingsPainter oldDelegate) {
    return oldDelegate.ringColor != ringColor;
  }
}
