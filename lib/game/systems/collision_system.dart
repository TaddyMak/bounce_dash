import 'dart:math' as math;
import 'dart:ui';

import '../components/obstacle.dart';
import '../components/platform.dart';
import '../components/player.dart';

class CollisionSystem {
  static bool shouldBounceOnPlatform(
    PlayerComponent player,
    PlatformComponent platform,
  ) {
    if (platform.consumed || player.velocity.y <= 0) {
      return false;
    }

    final platformTop = platform.position.y - (platform.size.y / 2);
    final previousBottom = player.previousPosition.y + player.radius;
    final currentBottom = player.position.y + player.radius;
    final horizontalDistance = (player.position.x - platform.position.x).abs();
    final withinHorizontalBounds =
        horizontalDistance <= (platform.size.x / 2) + player.radius - 6;

    return withinHorizontalBounds &&
        previousBottom <= platformTop + 6 &&
        currentBottom >= platformTop - 2;
  }

  static bool hitsObstacle(PlayerComponent player, ObstacleComponent obstacle) {
    final halfWidth = obstacle.size.x / 2;
    final halfHeight = obstacle.size.y / 2;
    final closestX = player.position.x.clamp(
      obstacle.position.x - halfWidth,
      obstacle.position.x + halfWidth,
    );
    final closestY = player.position.y.clamp(
      obstacle.position.y - halfHeight,
      obstacle.position.y + halfHeight,
    );
    final dx = player.position.x - closestX;
    final dy = player.position.y - closestY;

    return (dx * dx) + (dy * dy) <= math.pow(player.radius, 2);
  }

  static Rect visibleWorldRect(double cameraY, double width, double height) {
    return Rect.fromLTWH(0, cameraY, width, height);
  }
}
