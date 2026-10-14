import 'package:cloud_firestore/cloud_firestore.dart';

class Leaderboard {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<({int rank, String username, int score})>>
  getLeaderboard() async {
    final scores = <String, int>{};

    final words = await db.collection('words').get();
    for (final doc in words.docs) {
      final username = doc.data()['username'];
      if (username is String) scores[username] = 0;
    }

    final failures = await db
        .collection('gameResults')
        .where('solved', isEqualTo: false)
        .get();
    for (final doc in failures.docs) {
      final owner = doc.data()['ownerUsername'];
      if (owner is String) scores[owner] = (scores[owner] ?? 0) + 1;
    }

    final ranking = scores.entries.toList()
      ..sort((a, b) {
        final byScore = b.value.compareTo(a.value);
        if (byScore != 0) return byScore;
        return a.key.toLowerCase().compareTo(b.key.toLowerCase());
      });

    final leaderboard = <({int rank, String username, int score})>[];
    for (var i = 0; i < ranking.length; i++) {
      final tiedWithPrevious =
          i > 0 && ranking[i].value == ranking[i - 1].value;
      leaderboard.add((
        rank: tiedWithPrevious ? leaderboard[i - 1].rank : i + 1,
        username: ranking[i].key,
        score: ranking[i].value,
      ));
    }
    return leaderboard;
  }
}
