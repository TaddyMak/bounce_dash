import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/leaderboard/leaderboard_entry.dart';
import '../game/models/level_config.dart';
import '../game/systems/level_generator.dart';
import '../services/auth_service.dart';
import '../services/leaderboard_service.dart';
import '../services/local_storage_service.dart';
import 'router.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('SharedPreferences must be overridden.'),
);

final localStorageServiceProvider = Provider<LocalStorageService>(
  (ref) => LocalStorageService(ref.watch(sharedPreferencesProvider)),
);

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

final firebaseFirestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(ref.watch(firebaseAuthProvider)),
);

final leaderboardServiceProvider = Provider<LeaderboardService>(
  (ref) => LeaderboardService(
    firestore: ref.watch(firebaseFirestoreProvider),
    auth: ref.watch(firebaseAuthProvider),
  ),
);

final appRouterProvider = Provider<GoRouter>((ref) => buildRouter(ref));

final appBootstrapProvider = FutureProvider<AppBootstrapState>((ref) async {
  var firebaseReady = false;
  var anonymousAuthReady = false;
  String? warning;

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
    firebaseReady = true;
  } catch (_) {
    warning =
        'Firebase n’est pas encore configuré. Le jeu reste jouable en local.';
  }

  if (firebaseReady) {
    try {
      final user = await ref.read(authServiceProvider).signInAnonymously();
      anonymousAuthReady = user != null;
    } catch (_) {
      warning =
          'Connexion anonyme indisponible pour l’instant. Le leaderboard sera désactivé.';
    }
  }

  return AppBootstrapState(
    firebaseReady: firebaseReady,
    anonymousAuthReady: anonymousAuthReady,
    warning: warning,
  );
});

final campaignLevelsProvider = Provider<List<LevelConfig>>(
  (ref) => LevelGenerator.defaultCampaignLevels(),
);

final campaignProgressProvider = Provider<List<LevelProgress>>((ref) {
  final levels = ref.watch(campaignLevelsProvider);
  return ref
      .watch(localStorageServiceProvider)
      .getCampaignProgress(levels.length);
});

final playerDisplayNameProvider = Provider<String>(
  (ref) => ref.watch(localStorageServiceProvider).getPlayerDisplayName(),
);

final localInfiniteBestScoreProvider = Provider<int>(
  (ref) => ref.watch(localStorageServiceProvider).getInfiniteBestScore(),
);

final topScoresProvider = FutureProvider.family<List<LeaderboardEntry>, int>((
  ref,
  limit,
) async {
  return ref.watch(leaderboardServiceProvider).getTopScores(limit);
});

final userBestScoreProvider = FutureProvider.family<LeaderboardEntry?, String>((
  ref,
  userId,
) async {
  return ref.watch(leaderboardServiceProvider).getUserBestScore(userId);
});

class AppBootstrapState {
  const AppBootstrapState({
    required this.firebaseReady,
    required this.anonymousAuthReady,
    this.warning,
  });

  final bool firebaseReady;
  final bool anonymousAuthReady;
  final String? warning;
}
