import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bounce_dash/services/local_storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalStorageService', () {
    late LocalStorageService storage;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      storage = LocalStorageService(preferences);
    });

    test('saves and keeps best infinite score', () async {
      await storage.saveInfiniteBestScore(100);
      await storage.saveInfiniteBestScore(80);

      expect(storage.getInfiniteBestScore(), 100);
    });

    test('stores level progress and unlocks next level', () async {
      await storage.saveLevelProgress(
        levelNumber: 3,
        score: 420,
        completed: true,
      );

      final progress = storage.getLevelProgress(3);

      expect(progress.bestScore, 420);
      expect(progress.isCompleted, isTrue);
      expect(storage.getMaxUnlockedLevel(), 4);
    });

    test('uses Player when display name is empty', () async {
      await storage.savePlayerDisplayName(' ');

      expect(storage.getPlayerDisplayName(), 'Player');
    });
  });
}
