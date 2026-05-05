import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardEntry {
  const LeaderboardEntry({
    required this.userId,
    required this.displayName,
    required this.score,
    required this.height,
    required this.createdAt,
  });

  final String userId;
  final String displayName;
  final int score;
  final int height;
  final DateTime createdAt;

  factory LeaderboardEntry.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    final createdAt = data['createdAt'];

    return LeaderboardEntry(
      userId: data['userId'] as String? ?? '',
      displayName: data['displayName'] as String? ?? 'Player',
      score: (data['score'] as num? ?? 0).round(),
      height: (data['height'] as num? ?? 0).round(),
      createdAt: createdAt is Timestamp
          ? createdAt.toDate()
          : DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
