class LevelConfig {
  const LevelConfig({
    required this.levelNumber,
    required this.targetHeight,
    required this.verticalSpacing,
    required this.platformCount,
    required this.boostChance,
    required this.fragileChance,
    required this.movingChance,
    required this.dangerousChance,
    required this.obstacleCount,
  });

  final int levelNumber;
  final double targetHeight;
  final double verticalSpacing;
  final int platformCount;
  final double boostChance;
  final double fragileChance;
  final double movingChance;
  final double dangerousChance;
  final int obstacleCount;
}
