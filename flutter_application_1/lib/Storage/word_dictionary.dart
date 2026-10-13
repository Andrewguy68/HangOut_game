import 'dart:convert';

import 'package:flutter/services.dart';

/// (assets/words.txt, the public-domain ENABLE list, one word per line), so
/// checking a word is instant, offline and needs no API key.
class WordDictionary {
  WordDictionary(this._words);

  /// Builds a dictionary from text with one word per line.
  factory WordDictionary.fromText(String text) {
    final words = <String>{};
    for (final line in const LineSplitter().convert(text)) {
      final word = line.trim().toLowerCase();
      if (word.isNotEmpty) words.add(word);
    }
    return WordDictionary(words);
  }

  static const String assetPath = 'assets/words.txt';

  static Future<WordDictionary> loadAsset([AssetBundle? bundle]) async {
    final text = await (bundle ?? rootBundle).loadString(
      assetPath,
      cache: false,
    );
    return WordDictionary.fromText(text);
  }

  final Set<String> _words;

  int get length => _words.length;

  bool contains(String word) => _words.contains(word.trim().toLowerCase());
}
