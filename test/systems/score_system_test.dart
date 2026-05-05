import 'package:flutter_test/flutter_test.dart';

import 'package:bounce_dash/game/systems/score_system.dart';

void main() {
  test('score increases with height', () {
    final score = ScoreSystem.calculate(
      height: 900,
      combo: 1,
      platformsTouched: 10,
    );

    expect(score, greaterThanOrEqualTo(900));
  });

  test('combo grants bonus score', () {
    final baseScore = ScoreSystem.calculate(
      height: 600,
      combo: 1,
      platformsTouched: 8,
    );
    final comboScore = ScoreSystem.calculate(
      height: 600,
      combo: 4,
      platformsTouched: 8,
    );

    expect(comboScore, greaterThan(baseScore));
  });
}
