import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/game_constants.dart';
import '../../game/models/game_session_result.dart';

class LevelCompleteScreen extends StatelessWidget {
  const LevelCompleteScreen({required this.result, super.key});

  final GameSessionResult result;

  @override
  Widget build(BuildContext context) {
    final nextLevel = (result.levelNumber ?? 1) + 1;
    final hasNextLevel = nextLevel <= GameConstants.totalCampaignLevels;

    return Scaffold(
      appBar: AppBar(title: const Text('Niveau terminé')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bravo', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 10),
              Text('Niveau ${result.levelNumber} réussi'),
              Text('Score: ${result.score}'),
              Text('Hauteur: ${result.height} m'),
              if (result.isNewBest) ...[
                const SizedBox(height: 10),
                Text(
                  'Nouveau record sur ce niveau',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.green.shade700),
                ),
              ],
              const Spacer(),
              if (hasNextLevel) ...[
                FilledButton.icon(
                  onPressed: () =>
                      context.go('/gameplay/level', extra: nextLevel),
                  icon: const Icon(Icons.skip_next_rounded),
                  label: Text('Niveau $nextLevel'),
                ),
                const SizedBox(height: 12),
              ],
              OutlinedButton.icon(
                onPressed: () =>
                    context.go('/gameplay/level', extra: result.levelNumber),
                icon: const Icon(Icons.replay_rounded),
                label: const Text('Rejouer'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => context.go('/levels'),
                icon: const Icon(Icons.grid_view_rounded),
                label: const Text('Sélection des niveaux'),
              ),
              const SizedBox(height: 12),
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
