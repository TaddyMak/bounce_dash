import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class BackgroundComponent extends PositionComponent {
  double _elapsed = 0;

  @override
  void update(double dt) {
    _elapsed += dt;
    super.update(dt);
  }

  @override
  void onGameResize(Vector2 size) {
    this.size = size;
    super.onGameResize(size);
  }

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: const [Color(0xFF58CFFF), Color(0xFFB7F7FF)],
    );
    final fill = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, fill);

    final orbPaint = Paint()..color = Colors.white.withValues(alpha: 0.18);
    for (var index = 0; index < 5; index++) {
      final phase = _elapsed * (0.2 + index * 0.03);
      final x =
          (size.x * (0.15 + index * 0.18)) + math.sin(phase) * (12 + index * 3);
      final y =
          (size.y * (0.18 + index * 0.14)) + math.cos(phase) * (16 + index * 4);
      canvas.drawCircle(Offset(x, y), 18 + index * 6, orbPaint);
    }
  }
}
