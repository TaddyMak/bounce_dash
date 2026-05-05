import 'dart:math';

import '../models/platform_type.dart';
import 'level_generator.dart';

class InfiniteGenerator {
  InfiniteGenerator({int seed = 321}) : _random = Random(seed);

  final Random _random;

  InfiniteBatch generateBatch({
    required double startY,
    required double width,
    required int heightProgress,
  }) {
    final platforms = <PlatformSpawnData>[];
    final obstacles = <ObstacleSpawnData>[];
    final difficulty = 1 + (heightProgress / 1200);
    var currentY = startY;

    for (var index = 0; index < 12; index++) {
      currentY -= 78 + _random.nextDouble() * 34;
      final x = 44 + _random.nextDouble() * (width - 88);
      final type = _pickType(difficulty);
      platforms.add(PlatformSpawnData(x: x, y: currentY, type: type));

      if (difficulty > 1.8 && _random.nextDouble() < 0.22) {
        obstacles.add(
          ObstacleSpawnData(
            x: 42 + _random.nextDouble() * (width - 84),
            y: currentY - 36 - _random.nextDouble() * 22,
          ),
        );
      }
    }

    return InfiniteBatch(
      platforms: platforms,
      obstacles: obstacles,
      nextTopY: currentY,
    );
  }

  PlatformType _pickType(double difficulty) {
    final roll = _random.nextDouble();

    if (difficulty > 3.1 && roll < 0.12) {
      return PlatformType.dangerous;
    }
    if (difficulty > 2.2 && roll < 0.28) {
      return PlatformType.moving;
    }
    if (difficulty > 1.4 && roll < 0.46) {
      return PlatformType.fragile;
    }
    if (roll < 0.58) {
      return PlatformType.boost;
    }
    return PlatformType.normal;
  }
}

class InfiniteBatch {
  const InfiniteBatch({
    required this.platforms,
    required this.obstacles,
    required this.nextTopY,
  });

  final List<PlatformSpawnData> platforms;
  final List<ObstacleSpawnData> obstacles;
  final double nextTopY;
}
