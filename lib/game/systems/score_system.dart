class ScoreSystem {
  static int calculate({
    required int height,
    required int combo,
    required int platformsTouched,
  }) {
    final comboBonus = combo > 1 ? (combo - 1) * 8 : 0;
    final rhythmBonus = platformsTouched * 3;
    return height + comboBonus + rhythmBonus;
  }
}
