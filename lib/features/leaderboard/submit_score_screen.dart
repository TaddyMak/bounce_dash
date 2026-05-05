import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../constants/game_constants.dart';
import '../../game/models/game_session_result.dart';

class SubmitScoreScreen extends ConsumerStatefulWidget {
  const SubmitScoreScreen({required this.result, super.key});

  final GameSessionResult result;

  @override
  ConsumerState<SubmitScoreScreen> createState() => _SubmitScoreScreenState();
}

class _SubmitScoreScreenState extends ConsumerState<SubmitScoreScreen> {
  late final TextEditingController _controller;
  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(playerDisplayNameProvider),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _submitting = true;
      _error = null;
    });

    final displayName = _controller.text.trim().isEmpty
        ? GameConstants.defaultDisplayName
        : _controller.text.trim();

    try {
      await ref
          .read(localStorageServiceProvider)
          .savePlayerDisplayName(displayName);
      await ref
          .read(leaderboardServiceProvider)
          .submitScore(widget.result.score, widget.result.height, displayName);

      if (!mounted) {
        return;
      }

      context.go('/leaderboard');
    } catch (error) {
      setState(() {
        _error = error.toString();
        _submitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bootstrap = ref.watch(appBootstrapProvider).asData?.value;

    return Scaffold(
      appBar: AppBar(title: const Text('Soumettre le score')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Score ${widget.result.score}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text('Hauteur atteinte: ${widget.result.height} m'),
              const SizedBox(height: 24),
              TextField(
                controller: _controller,
                maxLength: 16,
                decoration: const InputDecoration(
                  labelText: 'Pseudo',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              if (bootstrap?.anonymousAuthReady != true)
                const Text(
                  'Le leaderboard est indisponible tant que Firebase n’est pas configuré.',
                ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const Spacer(),
              FilledButton.icon(
                onPressed: _submitting || bootstrap?.anonymousAuthReady != true
                    ? null
                    : _submit,
                icon: _submitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.cloud_upload_rounded),
                label: const Text('Envoyer au classement'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go('/menu'),
                child: const Text('Retour menu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
