import 'package:flutter_test/flutter_test.dart';

import 'package:bounce_dash/game/models/platform_type.dart';
import 'package:bounce_dash/game/systems/level_generator.dart';

void main() {
  test('default campaign contains 20 levels', () {
    final levels = LevelGenerator.defaultCampaignLevels();

    expect(levels, hasLength(20));
    expect(levels.first.levelNumber, 1);
    expect(levels.last.levelNumber, 20);
  });

  test('early levels do not spawn dangerous platforms', () {
    final generator = LevelGenerator();
    final level = LevelGenerator.defaultCampaignLevels()[1];

    final generated = generator.generateLevel(
      config: level,
      width: 360,
      startY: 540,
    );

    expect(
      generated.platforms.any(
        (platform) => platform.type == PlatformType.dangerous,
      ),
      isFalse,
    );
  });

  test('late levels can include advanced platform types', () {
    final generator = LevelGenerator();
    final level = LevelGenerator.defaultCampaignLevels().last;

    final generated = generator.generateLevel(
      config: level,
      width: 360,
      startY: 540,
    );

    expect(
      generated.platforms.any(
        (platform) => platform.type == PlatformType.moving,
      ),
      isTrue,
    );
    expect(generated.obstacles.isNotEmpty, isTrue);
  });
}
