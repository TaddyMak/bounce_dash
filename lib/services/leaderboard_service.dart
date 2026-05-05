import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants/game_constants.dart';
import '../features/leaderboard/leaderboard_entry.dart';

class LeaderboardService {
  LeaderboardService({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _leaderboardCollection =>
      _firestore.collection('leaderboard');

  Future<void> submitScore(int score, int height, String displayName) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('Aucun utilisateur Firebase connecté.');
    }

    final safeName = displayName.trim().isEmpty
        ? GameConstants.defaultDisplayName
        : displayName.trim();

    await _leaderboardCollection.add({
      'userId': user.uid,
      'displayName': safeName,
      'score': score,
      'height': height,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<LeaderboardEntry>> getTopScores(int limit) async {
    final snapshot = await _leaderboardCollection
        .orderBy('score', descending: true)
        .orderBy('createdAt', descending: false)
        .limit(limit)
        .get();

    return snapshot.docs.map(LeaderboardEntry.fromDocument).toList();
  }

  Future<LeaderboardEntry?> getUserBestScore(String userId) async {
    final snapshot = await _leaderboardCollection
        .where('userId', isEqualTo: userId)
        .orderBy('score', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    return LeaderboardEntry.fromDocument(snapshot.docs.first);
  }
}
