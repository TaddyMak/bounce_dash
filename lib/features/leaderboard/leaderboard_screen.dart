import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../constants/game_constants.dart';
import 'leaderboard_entry.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrap = ref.watch(appBootstrapProvider).asData?.value;
    final topScores = ref.watch(
      topScoresProvider(GameConstants.leaderboardFetchLimit),
    );
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final userBest = currentUserId == null
        ? null
        : ref.watch(userBestScoreProvider(currentUserId));

    return Scaffold(
      appBar: AppBar(title: const Text('Classement')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Top scores du mode infini',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                bootstrap?.firebaseReady == true
                    ? 'Lecture publique du leaderboard Firebase.'
                    : 'Firebase n’est pas encore configuré. Le classement sera vide tant que la configuration n’est pas terminée.',
              ),
              const SizedBox(height: 20),
              if (userBest != null)
                userBest.when(
                  data: (entry) => entry == null
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _UserBestCard(entry: entry),
                        ),
                  error: (error, stackTrace) => const SizedBox.shrink(),
                  loading: () => const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: LinearProgressIndicator(),
                  ),
                ),
              Expanded(
                child: topScores.when(
                  data: (scores) {
                    if (scores.isEmpty) {
                      return _EmptyLeaderboard(
                        canSubmit: bootstrap?.anonymousAuthReady == true,
                      );
                    }

                    return ListView.separated(
                      itemCount: scores.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final entry = scores[index];
                        return _ScoreRow(rank: index + 1, entry: entry);
                      },
                    );
                  },
                  error: (error, stackTrace) => Center(
                    child: Text('Impossible de charger le classement: $error'),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
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

class _UserBestCard extends StatelessWidget {
  const _UserBestCard({required this.entry});

  final LeaderboardEntry entry;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.person_rounded),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Ton meilleur score: ${entry.score} (${entry.height} m)',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  const _ScoreRow({required this.rank, required this.entry});

  final int rank;
  final LeaderboardEntry entry;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(child: Text('$rank')),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.displayName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text('${entry.height} m de hauteur'),
                ],
              ),
            ),
            Text(
              '${entry.score}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyLeaderboard extends StatelessWidget {
  const _EmptyLeaderboard({required this.canSubmit});

  final bool canSubmit;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.emoji_events_outlined, size: 54),
          const SizedBox(height: 12),
          Text(
            canSubmit
                ? 'Aucun score envoyé pour le moment.'
                : 'Firebase doit être configuré pour utiliser le leaderboard.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
