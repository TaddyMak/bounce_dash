import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../constants/game_constants.dart';
import 'components/background.dart';
import 'components/obstacle.dart';
import 'components/platform.dart';
import 'components/player.dart';
import 'models/game_mode.dart';
import 'models/game_session_result.dart';
import 'models/level_config.dart';
import 'models/platform_type.dart';
import 'systems/collision_system.dart';
import 'systems/infinite_generator.dart';
import 'systems/level_generator.dart';
import 'systems/score_system.dart';

class BounceDashGame extends FlameGame {
  BounceDashGame({
    required this.mode,
    this.levelConfig,
    required this.onGameOver,
    required this.onLevelComplete,
  }) : super(
         camera: CameraComponent.withFixedResolution(
           width: GameConstants.gameWidth,
           height: GameConstants.gameHeight,
         ),
       );

  final GameMode mode;
  final LevelConfig? levelConfig;
  final ValueChanged<GameSessionResult> onGameOver;
  final ValueChanged<GameSessionResult> onLevelComplete;

  final hud = ValueNotifier<GameHudData>(const GameHudData());

  final List<PlatformComponent> _platforms = [];
  final List<ObstacleComponent> _obstacles = [];
  final InfiniteGenerator _infiniteGenerator = InfiniteGenerator();
  final LevelGenerator _levelGenerator = LevelGenerator();

  late final PlayerComponent _player;
  double _cameraTop = 0;
  double _startY = 0;
  double _highestReached = 0;
  double _generatedTopY = 0;
  double _elapsed = 0;
  double _lastBounceAt = -99;
  int _combo = 0;
  int _platformsTouched = 0;
  int _score = 0;
  bool _finished = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.viewfinder.anchor = Anchor.topLeft;
    camera.viewfinder.position = Vector2.zero();
    camera.viewport.add(BackgroundComponent());

    _startY = GameConstants.gameHeight - 136;
    _player = PlayerComponent(
      position: Vector2(GameConstants.gameWidth / 2, _startY),
    );

    final startPlatform = PlatformComponent(
      platformType: PlatformType.normal,
      position: Vector2(GameConstants.gameWidth / 2, _startY + 42),
      width: 120,
    );

    await world.add(startPlatform);
    _platforms.add(startPlatform);

    await world.add(_player);
    _player.bounce(GameConstants.baseBounceVelocity);

    if (mode == GameMode.levels && levelConfig != null) {
      _loadLevel(levelConfig!);
    } else {
      _loadInfiniteWorld();
    }

    _updateHud();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_finished || !_player.isMounted) {
      return;
    }

    _elapsed += dt;
    _player.wrapHorizontally(GameConstants.gameWidth);
    _updateCamera();
    _processPlatformCollisions();
    _processObstacleCollisions();
    _cleanupWorld();
    _ensureInfiniteGeneration();
    _updateProgression();
    _checkLoseCondition();
    _checkLevelCompletion();
  }

  void handleTapDown(double localX) {
    if (_finished) {
      return;
    }

    final center = GameConstants.gameWidth / 2;
    final direction = localX < center ? -1.0 : 1.0;
    _player.nudgeHorizontal(direction);
  }

  void _loadLevel(LevelConfig config) {
    final generated = _levelGenerator.generateLevel(
      config: config,
      width: GameConstants.gameWidth,
      startY: _startY + 40,
    );

    _generatedTopY = generated.topY;
    _spawnBatch(generated.platforms, generated.obstacles);
  }

  void _loadInfiniteWorld() {
    _generatedTopY = _startY + 50;
    for (var batchIndex = 0; batchIndex < 3; batchIndex++) {
      final batch = _infiniteGenerator.generateBatch(
        startY: _generatedTopY,
        width: GameConstants.gameWidth,
        heightProgress: _highestReached.round(),
      );
      _generatedTopY = batch.nextTopY;
      _spawnBatch(batch.platforms, batch.obstacles);
    }
  }

  void _spawnBatch(
    List<PlatformSpawnData> platformData,
    List<ObstacleSpawnData> obstacleData,
  ) {
    for (final platform in platformData) {
      final component = PlatformComponent(
        platformType: platform.type,
        position: Vector2(platform.x, platform.y),
      );
      _platforms.add(component);
      world.add(component);
    }

    for (final obstacle in obstacleData) {
      final component = ObstacleComponent(
        position: Vector2(obstacle.x, obstacle.y),
      );
      _obstacles.add(component);
      world.add(component);
    }
  }

  void _processPlatformCollisions() {
    for (final platform in _platforms) {
      if (!platform.isMounted) {
        continue;
      }

      if (!CollisionSystem.shouldBounceOnPlatform(_player, platform)) {
        continue;
      }

      if (platform.isDeadly) {
        _finishGame(completed: false);
        return;
      }

      _combo = (_elapsed - _lastBounceAt) < 1.2 ? _combo + 1 : 1;
      _lastBounceAt = _elapsed;
      _platformsTouched += 1;
      _player.bounce(platform.platformType.bounceVelocity);
      platform.consume();

      for (final particle in createBounceBurst(
        Vector2(platform.position.x, platform.position.y - 4),
        color: platform.platformType.color,
      )) {
        world.add(particle);
      }
    }
  }

  void _processObstacleCollisions() {
    for (final obstacle in _obstacles) {
      if (!obstacle.isMounted) {
        continue;
      }

      if (CollisionSystem.hitsObstacle(_player, obstacle)) {
        _finishGame(completed: false);
        return;
      }
    }
  }

  void _cleanupWorld() {
    final visibleRect = CollisionSystem.visibleWorldRect(
      _cameraTop,
      GameConstants.gameWidth,
      GameConstants.gameHeight,
    );

    _platforms.removeWhere((platform) {
      final shouldRemove =
          !platform.isMounted || platform.position.y > visibleRect.bottom + 120;
      if (shouldRemove && platform.isMounted) {
        platform.removeFromParent();
      }
      return shouldRemove;
    });

    _obstacles.removeWhere((obstacle) {
      final shouldRemove =
          !obstacle.isMounted || obstacle.position.y > visibleRect.bottom + 120;
      if (shouldRemove && obstacle.isMounted) {
        obstacle.removeFromParent();
      }
      return shouldRemove;
    });
  }

  void _ensureInfiniteGeneration() {
    if (mode != GameMode.infinite) {
      return;
    }

    if (_player.position.y < _generatedTopY + 760) {
      final batch = _infiniteGenerator.generateBatch(
        startY: _generatedTopY,
        width: GameConstants.gameWidth,
        heightProgress: _highestReached.round(),
      );
      _generatedTopY = batch.nextTopY;
      _spawnBatch(batch.platforms, batch.obstacles);
    }
  }

  void _updateProgression() {
    final height = math.max(0.0, _startY - _player.position.y);
    if (height > _highestReached) {
      _highestReached = height.toDouble();
      _score = ScoreSystem.calculate(
        height: _highestReached.round(),
        combo: _combo,
        platformsTouched: _platformsTouched,
      );
      _updateHud();
    }
  }

  void _checkLoseCondition() {
    if (_player.position.y - _player.radius >
        _cameraTop + GameConstants.gameHeight + GameConstants.loseOffset) {
      _finishGame(completed: false);
    }
  }

  void _checkLevelCompletion() {
    if (mode != GameMode.levels || levelConfig == null) {
      return;
    }

    if (_highestReached >= levelConfig!.targetHeight) {
      _finishGame(completed: true);
    }
  }

  void _updateCamera() {
    final threshold = _cameraTop + (GameConstants.gameHeight * 0.38);
    if (_player.position.y < threshold) {
      final desiredTop = _player.position.y - (GameConstants.gameHeight * 0.38);
      _cameraTop += (desiredTop - _cameraTop) * 0.12;
      camera.viewfinder.position.y = _cameraTop;
    }
  }

  void _updateHud() {
    hud.value = GameHudData(
      score: _score,
      height: _highestReached.round(),
      combo: _combo,
      targetHeight: levelConfig?.targetHeight.round(),
      levelNumber: levelConfig?.levelNumber,
      mode: mode,
    );
  }

  void _finishGame({required bool completed}) {
    if (_finished) {
      return;
    }

    _finished = true;
    pauseEngine();

    final result = GameSessionResult(
      mode: mode,
      score: _score,
      height: _highestReached.round(),
      levelNumber: levelConfig?.levelNumber,
      targetHeight: levelConfig?.targetHeight,
      completed: completed,
    );

    if (completed) {
      onLevelComplete(result);
    } else {
      onGameOver(result);
    }
  }
}

class GameHudData {
  const GameHudData({
    this.score = 0,
    this.height = 0,
    this.combo = 0,
    this.targetHeight,
    this.levelNumber,
    this.mode = GameMode.infinite,
  });

  final int score;
  final int height;
  final int combo;
  final int? targetHeight;
  final int? levelNumber;
  final GameMode mode;
}
