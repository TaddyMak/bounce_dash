import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../constants/game_constants.dart';

class PlayerComponent extends CircleComponent {
  PlayerComponent({required Vector2 position})
    : velocity = Vector2.zero(),
      previousPosition = position.clone(),
      super(
        radius: GameConstants.playerRadius,
        position: position,
        anchor: Anchor.center,
        paint: Paint()..color = const Color(0xFFFF7F50),
      );

  final Vector2 velocity;
  final Vector2 previousPosition;

  @override
  void update(double dt) {
    previousPosition.setFrom(position);
    velocity.y += GameConstants.gravity * dt;
    position += velocity * dt;

    final drag = math.pow(GameConstants.horizontalDrag, dt * 60).toDouble();
    velocity.x *= drag;
    velocity.x = velocity.x.clamp(
      -GameConstants.maxHorizontalSpeed,
      GameConstants.maxHorizontalSpeed,
    );

    super.update(dt);
  }

  void nudgeHorizontal(double direction) {
    velocity.x += direction * GameConstants.horizontalImpulse;
    velocity.x = velocity.x.clamp(
      -GameConstants.maxHorizontalSpeed,
      GameConstants.maxHorizontalSpeed,
    );
  }

  void bounce(double force) {
    velocity.y = -force;
  }

  void wrapHorizontally(double width) {
    if (position.x < -radius) {
      position.x = width + radius;
    } else if (position.x > width + radius) {
      position.x = -radius;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.38);
    canvas.drawCircle(
      Offset(-radius * 0.35, -radius * 0.35),
      radius * 0.35,
      highlightPaint,
    );
  }
}

List<BounceParticle> createBounceBurst(Vector2 origin, {Color? color}) {
  final random = math.Random(origin.x.round() + origin.y.round());
  return List.generate(6, (index) {
    final angle = random.nextDouble() * math.pi;
    final speed = 55 + random.nextDouble() * 90;
    return BounceParticle(
      position: origin.clone(),
      velocity: Vector2(math.cos(angle) * speed, -math.sin(angle) * speed),
      color: color ?? const Color(0xFFFFF3B0),
    );
  });
}

class BounceParticle extends CircleComponent {
  BounceParticle({
    required Vector2 position,
    required this.velocity,
    required Color color,
  }) : _paint = Paint()..color = color,
       super(position: position, radius: 4, anchor: Anchor.center);

  final Vector2 velocity;
  final Paint _paint;
  double _life = 0.38;

  @override
  void update(double dt) {
    _life -= dt;
    if (_life <= 0) {
      removeFromParent();
      return;
    }

    velocity.y += 240 * dt;
    position += velocity * dt;
    radius = 1 + (_life * 6);
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    _paint.color = _paint.color.withValues(alpha: (_life / 0.38).clamp(0, 1));
    canvas.drawCircle(Offset.zero, radius, _paint);
  }
}
