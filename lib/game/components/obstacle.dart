import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../constants/game_constants.dart';

class ObstacleComponent extends RectangleComponent {
  ObstacleComponent({required Vector2 position, double? width, double? height})
    : super(
        position: position,
        anchor: Anchor.center,
        size: Vector2(
          width ?? GameConstants.obstacleWidth,
          height ?? GameConstants.obstacleHeight,
        ),
        paint: Paint()..color = const Color(0xFFE63946),
      );

  @override
  void render(Canvas canvas) {
    final path = Path();
    final segmentWidth = size.x / 4;

    path.moveTo(-size.x / 2, size.y / 2);
    for (var index = 0; index < 4; index++) {
      final left = -size.x / 2 + (index * segmentWidth);
      path.lineTo(left + (segmentWidth / 2), -size.y / 2);
      path.lineTo(left + segmentWidth, size.y / 2);
    }

    path.close();
    canvas.drawPath(path, paint);
  }
}
