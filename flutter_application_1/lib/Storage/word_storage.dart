import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_application_1/Storage/opponent.dart';

/// Where players' words live in Firestore: one document per player at
/// `words/{uid}` holding their current word:
///
///   word:        'apple'          (lowercase)
///   username:    'Ameksa'         (copied from users/{uid})
///   submittedAt: <server time>    (used for the 24 hour limit)

class WordStorage {
  final _db = FirebaseFirestore.instance;

  /// When [uid] last saved a word (server time), or null if they never did.
  Future<DateTime?> lastSubmittedAt(String uid) async {
    final snapshot = await _db.collection('words').doc(uid).get();
    final submittedAt = snapshot.data()?['submittedAt'];
    return submittedAt is Timestamp ? submittedAt.toDate() : null;
  }

  /// Saves [word] as [uid]'s current word.
  Future<void> saveWord({required String uid, required String word}) async {
    final profile = await _db.collection('users').doc(uid).get();
    final username = profile.data()?['username'];
    await _db.collection('words').doc(uid).set({
      'word': word,
      'username': username is String ? username : 'unknown',
      'submittedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Opponent?> randomOpponent({required String excludeUid}) async {
    final snapshot = await _db.collection('words').get();
    final candidates = <Opponent>[];
    for (final doc in snapshot.docs) {
      if (doc.id == excludeUid) continue;
      final data = doc.data();
      final word = data['word'];
      final username = data['username'];
      if (word is String && username is String) {
        candidates.add(Opponent(username: username, word: word));
      }
    }
    if (candidates.isEmpty) return null;
    return candidates[Random().nextInt(candidates.length)];
  }
  Future<void> saveWordResults(
    String username,
    String word,
    int failedAttempts,
  ) async {
    await _db.collection('wordResults').add({
      'username': username,
      'word': word.trim().toLowerCase(),
      'failedAttempts': failedAttempts,
    });
  }

  Future<Map<String, int>> getWordResults(String username) async {
    Map<String, int> results = {};

    var wordResults = await _db
        .collection('wordResults')
        .where('username', isEqualTo: username)
        .get();

    for (var i in wordResults.docs) {
      results[i['word']] = (i['failedAttempts'] as num).toInt();
    }

    return results;
  }
}
