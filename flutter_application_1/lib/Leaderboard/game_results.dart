import 'package:cloud_firestore/cloud_firestore.dart';

class GameResults {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> record({
    required String guesserUid,
    required String ownerUsername,
    required String word,
    required bool solved,
  }) {
    return db.collection('gameResults').add({
      'guesserUid': guesserUid,
      'ownerUsername': ownerUsername,
      'word': word,
      'solved': solved,
      'playedAt': FieldValue.serverTimestamp(),
    });
  }
}
