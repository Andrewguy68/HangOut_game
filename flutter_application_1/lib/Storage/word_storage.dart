import 'package:cloud_firestore/cloud_firestore.dart';

/// Where players' words live in Firestore: one document per player at
/// `words/{uid}` holding their current word:
///
///   word:        'apple'          (lowercase)
///   username:    'Ameksa'         (copied from users/{uid})
///   submittedAt: <server time>    (used for the 24 hour limit)
///
/// Adding a new word replaces the old one, so "play against a random
/// player's word" is just "pick a random document from `words`".
class WordStorage {
  final _db = FirebaseFirestore.instance;

  /// When [uid] last saved a word (server time), or null if they never did.
  Future<DateTime?> lastSubmittedAt(String uid) async {
    final snapshot = await _db.collection('words').doc(uid).get();
    final submittedAt = snapshot.data()?['submittedAt'];
    return submittedAt is Timestamp ? submittedAt.toDate() : null;
  }

  /// Saves [word] as [uid]'s current word. The Firestore rules (see the
  /// notes next to this feature) reject this if the 24 hour limit has not
  /// passed, so the limit holds even if someone bypasses the app.
  Future<void> saveWord({required String uid, required String word}) async {
    final profile = await _db.collection('users').doc(uid).get();
    final username = profile.data()?['username'];
    await _db.collection('words').doc(uid).set({
      'word': word,
      'username': username is String ? username : 'unknown',
      'submittedAt': FieldValue.serverTimestamp(),
    });
  }
}
