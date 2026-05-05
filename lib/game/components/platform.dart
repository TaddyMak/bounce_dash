import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../constants/game_constants.dart';
import '../models/platform_type.dart';

class PlatformComponent extends RectangleComponent {
  PlatformComponent({
    required this.platformType,
    required Vector2 position,
    double? width,
    this.moveRange = 56,
    this.moveSpeed = 72,
  }) : _originX = position.x,
       super(
         position: position,
         anchor: Anchor.center,
         size: Vector2(
           width ?? GameConstants.platformWidth,
           GameConstants.platformHeight,
         ),
         paint: Paint()..color = platformType.color,
       );

  final PlatformType platformType;
  final double moveRange;
  final double moveSpeed;
  final double _originX;

  bool consumed = false;
  int _direction = 1;

  bool get isDeadly => platformType == PlatformType.dangerous;

  @override
  void update(double dt) {
    if (platformType == PlatformType.moving) {
      position.x += _direction * moveSpeed * dt;
      final delta = position.x - _originX;
      if (delta.abs() >= moveRange) {
        _direction *= -1;
      }
    }
    super.update(dt);
  }

  void consume() {
    if (consumed) {
      return;
    }

    consumed = true;
    if (platformType == PlatformType.fragile) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromCenter(
      center: Offset.zero,
      width: size.x,
      height: size.y,
    );
    final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(14));
    canvas.drawRRect(rRect, paint);

    final sheen = Paint()
      ..color = Colors.white.withValues(alpha: 0.22)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-size.x / 2, -size.y / 2, size.x * 0.55, size.y * 0.42),
        const Radius.circular(10),
      ),
      sheen,
    );
  }
}
