import 'package:flutter/material.dart';

class ScannerOverlay extends StatelessWidget {
  const ScannerOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.25),
              Colors.transparent,
              Colors.black.withValues(alpha: 0.35),
            ],
            stops: const [0.0, 0.45, 1.0],
          ),
        ),
        child: Center(
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 24,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Stack(
              children: const [
                Positioned(
                  top: 16,
                  left: 16,
                  child: _CornerMarker(alignment: Alignment.topLeft),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: _CornerMarker(alignment: Alignment.topRight),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: _CornerMarker(alignment: Alignment.bottomLeft),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: _CornerMarker(alignment: Alignment.bottomRight),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CornerMarker extends StatelessWidget {
  const _CornerMarker({required this.alignment});

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: alignment.y < 0
                ? const BorderSide(color: Colors.white, width: 4)
                : BorderSide.none,
            bottom: alignment.y > 0
                ? const BorderSide(color: Colors.white, width: 4)
                : BorderSide.none,
            left: alignment.x < 0
                ? const BorderSide(color: Colors.white, width: 4)
                : BorderSide.none,
            right: alignment.x > 0
                ? const BorderSide(color: Colors.white, width: 4)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
