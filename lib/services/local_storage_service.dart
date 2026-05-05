import 'package:shared_preferences/shared_preferences.dart';

import '../constants/game_constants.dart';

class LocalStorageService {
  LocalStorageService(this._preferences);

  final SharedPreferences _preferences;

  static const _infiniteBestScoreKey = 'infinite_best_score';
  static const _unlockedLevelKey = 'max_unlocked_level';
  static const _displayNameKey = 'player_display_name';

  int getInfiniteBestScore() {
    return _preferences.getInt(_infiniteBestScoreKey) ?? 0;
  }

  Future<void> saveInfiniteBestScore(int score) async {
    final nextBest = score > getInfiniteBestScore()
        ? score
        : getInfiniteBestScore();
    await _preferences.setInt(_infiniteBestScoreKey, nextBest);
  }

  int getMaxUnlockedLevel() {
    return _preferences.getInt(_unlockedLevelKey) ?? 1;
  }

  Future<void> unlockLevel(int levelNumber) async {
    final current = getMaxUnlockedLevel();
    if (levelNumber > current) {
      await _preferences.setInt(_unlockedLevelKey, levelNumber);
    }
  }

  Future<void> saveLevelProgress({
    required int levelNumber,
    required int score,
    required bool completed,
  }) async {
    final current = getLevelProgress(levelNumber);
    final bestScore = score > current.bestScore ? score : current.bestScore;

    await _preferences.setInt(_bestScoreKey(levelNumber), bestScore);
    await _preferences.setBool(
      _completedKey(levelNumber),
      current.isCompleted || completed,
    );

    if (completed) {
      await unlockLevel(levelNumber + 1);
    }
  }

  LevelProgress getLevelProgress(int levelNumber) {
    return LevelProgress(
      levelNumber: levelNumber,
      bestScore: _preferences.getInt(_bestScoreKey(levelNumber)) ?? 0,
      isCompleted: _preferences.getBool(_completedKey(levelNumber)) ?? false,
    );
  }

  List<LevelProgress> getCampaignProgress(int levelCount) {
    return List.generate(levelCount, (index) => getLevelProgress(index + 1));
  }

  String getPlayerDisplayName() {
    return _preferences.getString(_displayNameKey) ??
        GameConstants.defaultDisplayName;
  }

  Future<void> savePlayerDisplayName(String displayName) async {
    final safeName = displayName.trim().isEmpty
        ? GameConstants.defaultDisplayName
        : displayName.trim();
    await _preferences.setString(_displayNameKey, safeName);
  }

  String _bestScoreKey(int levelNumber) => 'level_${levelNumber}_best_score';

  String _completedKey(int levelNumber) => 'level_${levelNumber}_completed';
}

class LevelProgress {
  const LevelProgress({
    required this.levelNumber,
    required this.bestScore,
    required this.isCompleted,
  });

  final int levelNumber;
  final int bestScore;
  final bool isCompleted;
}
