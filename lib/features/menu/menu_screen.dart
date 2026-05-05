import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../constants/game_constants.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrap = ref.watch(appBootstrapProvider).asData?.value;
    final palette = Theme.of(context).extension<BounceDashPalette>()!;
    final progress = ref.watch(campaignProgressProvider);
    final infiniteBestScore = ref.watch(localInfiniteBestScoreProvider);
    final latestUnlocked = ref
        .watch(localStorageServiceProvider)
        .getMaxUnlockedLevel();
    final completedLevels = progress.where((entry) => entry.isCompleted).length;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [palette.skyTop, palette.skyBottom],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_upward_rounded,
                        size: 36,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Bounce Dash',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  'Saute, dash et grimpe toujours plus haut.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.92),
                  ),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    _StatChip(
                      label: 'Best infini',
                      value: '$infiniteBestScore',
                    ),
                    _StatChip(
                      label: 'Progression',
                      value: '$completedLevels/20',
                    ),
                    _StatChip(
                      label: 'Leaderboard',
                      value: bootstrap?.firebaseReady == true ? 'On' : 'Off',
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _MenuButton(
                            label: 'Jouer',
                            icon: Icons.play_arrow_rounded,
                            onPressed: () => context.go(
                              '/gameplay/level',
                              extra: latestUnlocked.clamp(
                                1,
                                GameConstants.totalCampaignLevels,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          _MenuButton(
                            label: 'Mode Infini',
                            icon: Icons.all_inclusive_rounded,
                            onPressed: () => context.go('/gameplay/infinite'),
                          ),
                          const SizedBox(height: 14),
                          _MenuButton(
                            label: 'Niveaux',
                            icon: Icons.grid_view_rounded,
                            onPressed: () => context.go('/levels'),
                          ),
                          const SizedBox(height: 14),
                          OutlinedButton.icon(
                            onPressed: () => context.go('/leaderboard'),
                            icon: const Icon(Icons.leaderboard_rounded),
                            label: const Text('Classement'),
                          ),
                          const Spacer(),
                          if (bootstrap?.warning != null)
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: palette.accentWarm.withValues(
                                  alpha: 0.18,
                                ),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.info_outline_rounded),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      bootstrap!.warning!,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text('$label: $value'));
  }
}
