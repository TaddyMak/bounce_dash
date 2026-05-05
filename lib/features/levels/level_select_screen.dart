import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../game/models/level_config.dart';
import '../../services/local_storage_service.dart';

class LevelSelectScreen extends ConsumerWidget {
  const LevelSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levels = ref.watch(campaignLevelsProvider);
    final progress = ref.watch(campaignProgressProvider);
    final unlocked = ref
        .watch(localStorageServiceProvider)
        .getMaxUnlockedLevel();

    return Scaffold(
      appBar: AppBar(title: const Text('Sélection des niveaux')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '20 niveaux courts avec une difficulté progressive.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  itemCount: levels.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.95,
                  ),
                  itemBuilder: (context, index) {
                    final level = levels[index];
                    final levelProgress = progress[index];
                    final isUnlocked = level.levelNumber <= unlocked;

                    return _LevelCard(
                      level: level,
                      progress: levelProgress,
                      isUnlocked: isUnlocked,
                      onPressed: isUnlocked
                          ? () => context.go(
                              '/gameplay/level',
                              extra: level.levelNumber,
                            )
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({
    required this.level,
    required this.progress,
    required this.isUnlocked,
    this.onPressed,
  });

  final LevelConfig level;
  final LevelProgress progress;
  final bool isUnlocked;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Niv. ${level.levelNumber}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  Icon(
                    isUnlocked ? Icons.lock_open_rounded : Icons.lock_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text('Objectif: ${level.targetHeight.round()} m'),
              const SizedBox(height: 6),
              Text('Best: ${progress.bestScore}'),
              const Spacer(),
              Text(
                progress.isCompleted ? 'Terminé' : 'À battre',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: progress.isCompleted
                      ? Colors.green.shade700
                      : Colors.orange.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
