import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter_application_1/storage/word_storage.dart";

class Leaderboard {
  // getresults{}
  // get the failedAttempts
  // add them to a database
  // sort the database
  // retrive rank 1 - 5
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<({int rank, String username, int failedAttempts})>> getLeaderboard() async {
    Map<String, int> results = {};

    var wordResults = await db.collection('wordResults').get();

    for (var i in wordResults.docs) {
      String username = i['username'];
      int attempts = i['failedAttempts'];

      results[username] = (results[username] ?? 0) + attempts;
    }

    var ranking = results.entries.toList(); //usernames and failedAttempts grouped together

    ranking.sort((a, b) {
      if (a.value < b.value) {
        return -1;
      }
      if (a.value > b.value) {
        return 1;
      }
      return 0;
    });

    List<({int rank, String username, int failedAttempts})> leaderboard = [];

    for (var i = 0; i < ranking.length && i < 5; i++) {
      leaderboard.add((
        rank: i + 1,
        username: ranking[i].key,
        failedAttempts: ranking[i].value
      ));
    }

    return leaderboard;
  }
}