import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../game/bounce_dash_game.dart';
import '../../game/models/game_mode.dart';
import '../../game/models/game_session_result.dart';

class GameplayScreen extends ConsumerStatefulWidget {
  const GameplayScreen({required this.mode, this.levelNumber, super.key});

  final GameMode mode;
  final int? levelNumber;

  @override
  ConsumerState<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends ConsumerState<GameplayScreen> {
  late final BounceDashGame _game;

  @override
  void initState() {
    super.initState();
    final levels = ref.read(campaignLevelsProvider);
    final levelConfig = widget.mode == GameMode.levels
        ? levels[(widget.levelNumber ?? 1) - 1]
        : null;

    _game = BounceDashGame(
      mode: widget.mode,
      levelConfig: levelConfig,
      onGameOver: _handleGameOver,
      onLevelComplete: _handleLevelComplete,
    );
  }

  Future<void> _handleGameOver(GameSessionResult result) async {
    final storage = ref.read(localStorageServiceProvider);
    GameSessionResult payload = result;

    if (result.mode == GameMode.infinite) {
      final previousBest = storage.getInfiniteBestScore();
      final isNewBest = result.score > previousBest;
      await storage.saveInfiniteBestScore(result.score);
      payload = result.copyWith(isNewBest: isNewBest);
      ref.invalidate(localInfiniteBestScoreProvider);
    } else if (result.levelNumber != null) {
      final existing = storage.getLevelProgress(result.levelNumber!);
      final isNewBest = result.score > existing.bestScore;
      await storage.saveLevelProgress(
        levelNumber: result.levelNumber!,
        score: result.score,
        completed: false,
      );
      payload = result.copyWith(isNewBest: isNewBest);
      ref.invalidate(campaignProgressProvider);
    }

    if (!mounted) {
      return;
    }

    context.go('/game-over', extra: payload);
  }

  Future<void> _handleLevelComplete(GameSessionResult result) async {
    if (result.levelNumber == null) {
      return;
    }

    final storage = ref.read(localStorageServiceProvider);
    final existing = storage.getLevelProgress(result.levelNumber!);
    final isNewBest = result.score > existing.bestScore;

    await storage.saveLevelProgress(
      levelNumber: result.levelNumber!,
      score: result.score,
      completed: true,
    );

    ref.invalidate(campaignProgressProvider);

    if (!mounted) {
      return;
    }

    context.go('/level-complete', extra: result.copyWith(isNewBest: isNewBest));
  }

  @override
  void dispose() {
    _game.hud.dispose();
    _game.removeAll(_game.children);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<BounceDashPalette>()!;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (details) {
                  final width = MediaQuery.sizeOf(context).width;
                  final safeWidth = width <= 0 ? 1.0 : width;
                  final localX =
                      details.localPosition.dx * (_game.size.x / safeWidth);
                  _game.handleTapDown(localX);
                },
                child: GameWidget(game: _game),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: ValueListenableBuilder<GameHudData>(
                valueListenable: _game.hud,
                builder: (context, hud, child) {
                  return Row(
                    children: [
                      _HudPill(label: 'Score', value: '${hud.score}'),
                      const SizedBox(width: 10),
                      _HudPill(label: 'Hauteur', value: '${hud.height} m'),
                      const SizedBox(width: 10),
                      _HudPill(label: 'Combo', value: 'x${hud.combo}'),
                    ],
                  );
                },
              ),
            ),
            Positioned(
              top: 70,
              left: 16,
              right: 16,
              child: ValueListenableBuilder<GameHudData>(
                valueListenable: _game.hud,
                builder: (context, hud, child) {
                  final subtitle = hud.mode == GameMode.levels
                      ? 'Niveau ${hud.levelNumber} • Objectif ${hud.targetHeight ?? 0} m'
                      : 'Mode infini • Monte le plus haut possible';

                  return Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: palette.accentDanger,
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 22,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  Expanded(
                    child: _TapHint(
                      icon: Icons.west_rounded,
                      label: 'Tap gauche',
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _TapHint(
                      icon: Icons.east_rounded,
                      label: 'Tap droite',
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton.filledTonal(
                onPressed: () => context.go('/menu'),
                icon: const Icon(Icons.close_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HudPill extends StatelessWidget {
  const _HudPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}

class _TapHint extends StatelessWidget {
  const _TapHint({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
