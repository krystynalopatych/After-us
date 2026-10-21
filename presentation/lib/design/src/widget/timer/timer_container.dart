import 'dart:math';

import 'package:flutter/material.dart';
import 'package:presentation/design/src/theme/design_system_theme.dart';
import 'package:presentation/generated/assets/assets.gen.dart';

final class TimerContainer extends StatelessWidget {
  static const _doneSizeFactor = 0.6;

  final double progress;
  final bool isDone;

  const TimerContainer({
    super.key,
    required this.progress,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    final images = Assets.resources.assets.images;

    return Stack(
      fit: .expand,
      children: [
        images.imgCircleTimer.image(fit: .contain),
        if (isDone)
          Center(
            child: FractionallySizedBox(
              widthFactor: _doneSizeFactor,
              heightFactor: _doneSizeFactor,
              child: images.imgDoneIcon.image(fit: .contain),
            ),
          )
        else
          CustomPaint(
            painter: _TimerPainter(
              progress: progress,
              color: DesignSystemTheme.of(context).colors.base.yellow,
            ),
          ),
      ],
    );
  }
}

final class _TimerPainter extends CustomPainter {
  static const _segmentCount = 12;
  static const _radiusFactor = 0.6;
  static const _strokeFactor = 0.14;
  static const _gapFactor = 0.25;

  final double progress;
  final Color color;

  const _TimerPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final radius = size.shortestSide / 2;
    final paint = Paint()
      ..color = color
      ..style = .stroke
      ..strokeWidth = radius * _strokeFactor;
    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: radius * _radiusFactor,
    );
    final sweep = 2 * pi / _segmentCount;
    final filled = (progress * _segmentCount).floor();
    for (var i = 0; i < filled; i++) {
      canvas.drawArc(
        rect,
        -pi / 2 + i * sweep + sweep * _gapFactor / 2,
        sweep * (1 - _gapFactor),
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_TimerPainter oldDelegate) => oldDelegate.progress != progress || oldDelegate.color != color;
}
