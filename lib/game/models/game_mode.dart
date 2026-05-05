enum GameMode {
  levels,
  infinite;

  String get routeName => this == GameMode.levels ? 'level' : 'infinite';
}
