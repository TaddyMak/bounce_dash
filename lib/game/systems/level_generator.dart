import 'dart:math';

import '../models/level_config.dart';
import '../models/platform_type.dart';

class LevelGenerator {
  GeneratedLevel generateLevel({
    required LevelConfig config,
    required double width,
    required double startY,
  }) {
    final random = Random(config.levelNumber * 97);
    final platforms = <PlatformSpawnData>[];
    final obstacles = <ObstacleSpawnData>[];
    var currentY = startY - 120;

    for (var index = 0; index < config.platformCount; index++) {
      currentY -= config.verticalSpacing + random.nextDouble() * 22;
      final x = 48 + random.nextDouble() * (width - 96);
      final type = _pickPlatformType(config, random);

      platforms.add(PlatformSpawnData(x: x, y: currentY, type: type));
    }

    for (var index = 0; index < config.obstacleCount; index++) {
      final y = startY - 260 - random.nextDouble() * config.targetHeight;
      final x = 44 + random.nextDouble() * (width - 88);
      obstacles.add(ObstacleSpawnData(x: x, y: y));
    }

    return GeneratedLevel(
      platforms: platforms,
      obstacles: obstacles,
      topY: currentY,
    );
  }

  static List<LevelConfig> defaultCampaignLevels() {
    return const [
      LevelConfig(
        levelNumber: 1,
        targetHeight: 900,
        verticalSpacing: 72,
        platformCount: 16,
        boostChance: 0.05,
        fragileChance: 0,
        movingChance: 0,
        dangerousChance: 0,
        obstacleCount: 0,
      ),
      LevelConfig(
        levelNumber: 2,
        targetHeight: 1020,
        verticalSpacing: 74,
        platformCount: 17,
        boostChance: 0.05,
        fragileChance: 0,
        movingChance: 0,
        dangerousChance: 0,
        obstacleCount: 0,
      ),
      LevelConfig(
        levelNumber: 3,
        targetHeight: 1140,
        verticalSpacing: 76,
        platformCount: 18,
        boostChance: 0.08,
        fragileChance: 0,
        movingChance: 0,
        dangerousChance: 0,
        obstacleCount: 0,
      ),
      LevelConfig(
        levelNumber: 4,
        targetHeight: 1260,
        verticalSpacing: 78,
        platformCount: 18,
        boostChance: 0.08,
        fragileChance: 0.18,
        movingChance: 0,
        dangerousChance: 0,
        obstacleCount: 0,
      ),
      LevelConfig(
        levelNumber: 5,
        targetHeight: 1400,
        verticalSpacing: 80,
        platformCount: 19,
        boostChance: 0.10,
        fragileChance: 0.22,
        movingChance: 0,
        dangerousChance: 0,
        obstacleCount: 0,
      ),
      LevelConfig(
        levelNumber: 6,
        targetHeight: 1540,
        verticalSpacing: 82,
        platformCount: 20,
        boostChance: 0.12,
        fragileChance: 0.26,
        movingChance: 0,
        dangerousChance: 0,
        obstacleCount: 1,
      ),
      LevelConfig(
        levelNumber: 7,
        targetHeight: 1680,
        verticalSpacing: 84,
        platformCount: 20,
        boostChance: 0.12,
        fragileChance: 0.12,
        movingChance: 0.18,
        dangerousChance: 0,
        obstacleCount: 1,
      ),
      LevelConfig(
        levelNumber: 8,
        targetHeight: 1840,
        verticalSpacing: 86,
        platformCount: 21,
        boostChance: 0.12,
        fragileChance: 0.12,
        movingChance: 0.22,
        dangerousChance: 0,
        obstacleCount: 1,
      ),
      LevelConfig(
        levelNumber: 9,
        targetHeight: 2000,
        verticalSpacing: 88,
        platformCount: 21,
        boostChance: 0.12,
        fragileChance: 0.14,
        movingChance: 0.25,
        dangerousChance: 0,
        obstacleCount: 1,
      ),
      LevelConfig(
        levelNumber: 10,
        targetHeight: 2160,
        verticalSpacing: 90,
        platformCount: 22,
        boostChance: 0.14,
        fragileChance: 0.14,
        movingChance: 0.28,
        dangerousChance: 0,
        obstacleCount: 2,
      ),
      LevelConfig(
        levelNumber: 11,
        targetHeight: 2340,
        verticalSpacing: 92,
        platformCount: 22,
        boostChance: 0.14,
        fragileChance: 0.12,
        movingChance: 0.20,
        dangerousChance: 0.10,
        obstacleCount: 3,
      ),
      LevelConfig(
        levelNumber: 12,
        targetHeight: 2520,
        verticalSpacing: 94,
        platformCount: 23,
        boostChance: 0.14,
        fragileChance: 0.12,
        movingChance: 0.20,
        dangerousChance: 0.12,
        obstacleCount: 3,
      ),
      LevelConfig(
        levelNumber: 13,
        targetHeight: 2700,
        verticalSpacing: 96,
        platformCount: 23,
        boostChance: 0.16,
        fragileChance: 0.14,
        movingChance: 0.20,
        dangerousChance: 0.14,
        obstacleCount: 3,
      ),
      LevelConfig(
        levelNumber: 14,
        targetHeight: 2920,
        verticalSpacing: 98,
        platformCount: 24,
        boostChance: 0.16,
        fragileChance: 0.14,
        movingChance: 0.22,
        dangerousChance: 0.16,
        obstacleCount: 4,
      ),
      LevelConfig(
        levelNumber: 15,
        targetHeight: 3140,
        verticalSpacing: 100,
        platformCount: 24,
        boostChance: 0.16,
        fragileChance: 0.14,
        movingChance: 0.22,
        dangerousChance: 0.18,
        obstacleCount: 4,
      ),
      LevelConfig(
        levelNumber: 16,
        targetHeight: 3380,
        verticalSpacing: 102,
        platformCount: 25,
        boostChance: 0.18,
        fragileChance: 0.18,
        movingChance: 0.24,
        dangerousChance: 0.18,
        obstacleCount: 4,
      ),
      LevelConfig(
        levelNumber: 17,
        targetHeight: 3620,
        verticalSpacing: 104,
        platformCount: 25,
        boostChance: 0.18,
        fragileChance: 0.20,
        movingChance: 0.24,
        dangerousChance: 0.20,
        obstacleCount: 5,
      ),
      LevelConfig(
        levelNumber: 18,
        targetHeight: 3880,
        verticalSpacing: 106,
        platformCount: 26,
        boostChance: 0.18,
        fragileChance: 0.20,
        movingChance: 0.26,
        dangerousChance: 0.22,
        obstacleCount: 5,
      ),
      LevelConfig(
        levelNumber: 19,
        targetHeight: 4140,
        verticalSpacing: 108,
        platformCount: 26,
        boostChance: 0.20,
        fragileChance: 0.20,
        movingChance: 0.28,
        dangerousChance: 0.22,
        obstacleCount: 5,
      ),
      LevelConfig(
        levelNumber: 20,
        targetHeight: 4400,
        verticalSpacing: 110,
        platformCount: 27,
        boostChance: 0.20,
        fragileChance: 0.22,
        movingChance: 0.30,
        dangerousChance: 0.24,
        obstacleCount: 6,
      ),
    ];
  }

  PlatformType _pickPlatformType(LevelConfig config, Random random) {
    final roll = random.nextDouble();

    if (roll < config.dangerousChance) {
      return PlatformType.dangerous;
    }
    if (roll < config.dangerousChance + config.movingChance) {
      return PlatformType.moving;
    }
    if (roll <
        config.dangerousChance + config.movingChance + config.fragileChance) {
      return PlatformType.fragile;
    }
    if (roll <
        config.dangerousChance +
            config.movingChance +
            config.fragileChance +
            config.boostChance) {
      return PlatformType.boost;
    }
    return PlatformType.normal;
  }
}

class GeneratedLevel {
  const GeneratedLevel({
    required this.platforms,
    required this.obstacles,
    required this.topY,
  });

  final List<PlatformSpawnData> platforms;
  final List<ObstacleSpawnData> obstacles;
  final double topY;
}

class PlatformSpawnData {
  const PlatformSpawnData({
    required this.x,
    required this.y,
    required this.type,
  });

  final double x;
  final double y;
  final PlatformType type;
}

class ObstacleSpawnData {
  const ObstacleSpawnData({required this.x, required this.y});

  final double x;
  final double y;
}
