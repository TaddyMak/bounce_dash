import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../game/models/game_mode.dart';
import '../../game/models/game_session_result.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({required this.result, super.key});

  final GameSessionResult result;

  @override
  Widget build(BuildContext context) {
    final isInfinite = result.mode == GameMode.infinite;

    return Scaffold(
      appBar: AppBar(title: const Text('Game Over')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Partie terminée',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text('Score: ${result.score}'),
              Text('Hauteur: ${result.height} m'),
              if (result.levelNumber != null)
                Text('Niveau: ${result.levelNumber}'),
              if (result.isNewBest) ...[
                const SizedBox(height: 10),
                Text(
                  'Nouveau meilleur score local',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.green.shade700),
                ),
              ],
              const Spacer(),
              FilledButton.icon(
                onPressed: () => context.go(
                  '/gameplay/${result.mode.routeName}',
                  extra: result.levelNumber,
                ),
                icon: const Icon(Icons.replay_rounded),
                label: const Text('Rejouer'),
              ),
              const SizedBox(height: 12),
              if (isInfinite) ...[
                OutlinedButton.icon(
                  onPressed: () => context.go('/submit-score', extra: result),
                  icon: const Icon(Icons.cloud_upload_rounded),
                  label: const Text('Envoyer son score'),
                ),
                const SizedBox(height: 12),
              ],
              OutlinedButton.icon(
                onPressed: () => context.go('/menu'),
                icon: const Icon(Icons.home_rounded),
                label: const Text('Retour menu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
