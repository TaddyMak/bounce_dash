import 'game_mode.dart';

class GameSessionResult {
  const GameSessionResult({
    required this.mode,
    required this.score,
    required this.height,
    this.levelNumber,
    this.targetHeight,
    this.completed = false,
    this.isNewBest = false,
  });

  final GameMode mode;
  final int score;
  final int height;
  final int? levelNumber;
  final double? targetHeight;
  final bool completed;
  final bool isNewBest;

  GameSessionResult copyWith({
    GameMode? mode,
    int? score,
    int? height,
    int? levelNumber,
    double? targetHeight,
    bool? completed,
    bool? isNewBest,
  }) {
    return GameSessionResult(
      mode: mode ?? this.mode,
      score: score ?? this.score,
      height: height ?? this.height,
      levelNumber: levelNumber ?? this.levelNumber,
      targetHeight: targetHeight ?? this.targetHeight,
      completed: completed ?? this.completed,
      isNewBest: isNewBest ?? this.isNewBest,
    );
  }
}
