import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/gameplay/game_over_screen.dart';
import '../features/gameplay/gameplay_screen.dart';
import '../features/gameplay/level_complete_screen.dart';
import '../features/leaderboard/leaderboard_screen.dart';
import '../features/leaderboard/submit_score_screen.dart';
import '../features/levels/level_select_screen.dart';
import '../features/menu/menu_screen.dart';
import '../features/menu/splash_screen.dart';
import '../game/models/game_mode.dart';
import '../game/models/game_session_result.dart';

GoRouter buildRouter(Ref ref) {
  return GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/menu', builder: (context, state) => const MenuScreen()),
      GoRoute(
        path: '/levels',
        builder: (context, state) => const LevelSelectScreen(),
      ),
      GoRoute(
        path: '/leaderboard',
        builder: (context, state) => const LeaderboardScreen(),
      ),
      GoRoute(
        path: '/submit-score',
        builder: (context, state) {
          final result = state.extra;
          if (result is! GameSessionResult) {
            return const _RouteErrorScreen(message: 'Score introuvable.');
          }
          return SubmitScoreScreen(result: result);
        },
      ),
      GoRoute(
        path: '/gameplay/:mode',
        builder: (context, state) {
          final modeParam = state.pathParameters['mode'] ?? 'infinite';
          final mode = modeParam == 'level'
              ? GameMode.levels
              : GameMode.infinite;
          final levelNumber = state.extra is int ? state.extra as int : null;

          return GameplayScreen(mode: mode, levelNumber: levelNumber);
        },
      ),
      GoRoute(
        path: '/game-over',
        builder: (context, state) {
          final result = state.extra;
          if (result is! GameSessionResult) {
            return const _RouteErrorScreen(
              message: 'Résultat de partie manquant.',
            );
          }
          return GameOverScreen(result: result);
        },
      ),
      GoRoute(
        path: '/level-complete',
        builder: (context, state) {
          final result = state.extra;
          if (result is! GameSessionResult) {
            return const _RouteErrorScreen(
              message: 'Niveau terminé introuvable.',
            );
          }
          return LevelCompleteScreen(result: result);
        },
      ),
    ],
  );
}

class _RouteErrorScreen extends StatelessWidget {
  const _RouteErrorScreen({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(message, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
