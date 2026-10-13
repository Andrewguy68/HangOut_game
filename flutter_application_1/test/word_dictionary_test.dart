import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/Storage/word_dictionary.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WordDictionary', () {
    test('contains is case-insensitive and ignores surrounding whitespace', () {
      final dictionary = WordDictionary({'apple'});

      expect(dictionary.contains('apple'), isTrue);
      expect(dictionary.contains('APPLE'), isTrue);
      expect(dictionary.contains('  Apple '), isTrue);
    });

    test('does not contain unknown words, empty input or partial words', () {
      final dictionary = WordDictionary({'apple'});

      expect(dictionary.contains('banana'), isFalse);
      expect(dictionary.contains(''), isFalse);
      expect(dictionary.contains('app'), isFalse);
    });

    test('fromText reads one word per line, skipping blanks and trimming', () {
      final dictionary = WordDictionary.fromText(
        'Apple\r\n  house \n\nstone\n',
      );

      expect(dictionary.length, 3);
      expect(dictionary.contains('apple'), isTrue);
      expect(dictionary.contains('house'), isTrue);
      expect(dictionary.contains('stone'), isTrue);
    });

    test('fromText ignores duplicate lines', () {
      final dictionary = WordDictionary.fromText('apple\napple\nAPPLE\n');

      expect(dictionary.length, 1);
    });
  });

  group('bundled word list', () {
    late WordDictionary bundled;

    setUpAll(() async {
      bundled = await WordDictionary.loadAsset();
    });

    test('loads with a full-size word list', () {
      expect(bundled.length, greaterThan(100000));
    });

    test('knows common words', () {
      for (final word in ['apple', 'house', 'stone', 'hangman', 'keyboard']) {
        expect(bundled.contains(word), isTrue, reason: word);
      }
    });

    test('rejects gibberish', () {
      for (final word in ['zzzzqx', 'asdfgh', 'xqzjv']) {
        expect(bundled.contains(word), isFalse, reason: word);
      }
    });
  });
}
