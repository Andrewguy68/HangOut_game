import 'package:firebase_core/firebase_core.dart' show FirebaseException;

import 'package:flutter_application_1/Storage/word_dictionary.dart';
import 'package:flutter_application_1/Storage/word_rules.dart';
import 'package:flutter_application_1/Storage/word_storage.dart';
import 'package:flutter_application_1/auth_service.dart';

/// Runs every check a new word must pass, then saves it..
///   1. the player is signed in
///   2. the word has an acceptable shape (letters only, 3-15 long)
///   3. the player has not added a word in the last 24 hours
///   4. the word is in the dictionary
///   5. save it
class WordService {
  WordService({
    required WordStorage storage,
    required AuthService auth,
    Future<WordDictionary> Function()? loadDictionary,
    DateTime Function()? now,
  }) : _storage = storage,
       _auth = auth,
       _loadDictionary = loadDictionary ?? (() => WordDictionary.loadAsset()),
       _now = now ?? DateTime.now;

  final WordStorage _storage;
  final AuthService _auth;
  final Future<WordDictionary> Function() _loadDictionary;
  final DateTime Function() _now;

  WordDictionary? _dictionary;

  /// Validates and saves [raw]. Returns the word as saved (trimmed,
  /// lowercase). Throws a [WordException] with a user-friendly message when a
  /// check fails; storage errors are passed through
  Future<String> submitWord(String raw) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const WordException('You need to be signed in to add a word.');
    }

    final shapeError = WordRules.validate(raw);
    if (shapeError != null) throw WordException(shapeError);
    final word = WordRules.normalize(raw);

    final last = await _storage.lastSubmittedAt(user.uid);
    final remaining = WordRules.cooldownRemaining(last, _now());
    if (remaining > Duration.zero) {
      throw WordException(WordRules.cooldownMessage(remaining));
    }

    final dictionary = await _getDictionary();
    if (!dictionary.contains(word)) {
      throw WordException(
        '"$word" isn\'t in the dictionary. Try another word.',
      );
    }

    await _storage.saveWord(uid: user.uid, word: word);
    return word;
  }

  // Loaded on first use and kept, so only the first submit pays for parsing
  // the word list. A failed load is not cached, so the next try can retry.
  Future<WordDictionary> _getDictionary() async {
    final cached = _dictionary;
    if (cached != null) return cached;
    final loaded = await _loadDictionary();
    return _dictionary = loaded;
  }
}

/// Turns anything thrown by [WordService] into a message that is safe and
/// useful to show to the user.
String wordErrorMessage(Object error) {
  if (error is WordException) return error.message;
  if (error is FirebaseException) {
    switch (error.code) {
      case 'permission-denied':
        return "Your word couldn't be saved. Remember: one word every 24 hours.";
      case 'unavailable':
        return 'No connection. Check your network and try again.';
      default:
        return 'Could not save your word. Please try again.';
    }
  }
  return 'Something went wrong. Please try again.';
}
