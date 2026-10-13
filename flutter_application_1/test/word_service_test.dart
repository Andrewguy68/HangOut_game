import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/Storage/word_dictionary.dart';
import 'package:flutter_application_1/Storage/word_rules.dart';
import 'package:flutter_application_1/Storage/word_service.dart';

import 'helpers/fake_auth_service.dart';
import 'helpers/fake_word_storage.dart';

final fixedNow = DateTime(2026, 10, 12, 12);

FakeAuthService signedIn() => FakeAuthService(signedInUser: FakeUser('abc'));

WordService buildService({
  required FakeWordStorage storage,
  FakeAuthService? auth,
  Future<WordDictionary> Function()? loadDictionary,
}) {
  return WordService(
    storage: storage,
    auth: auth ?? signedIn(),
    loadDictionary:
        loadDictionary ?? () async => WordDictionary({'apple', 'house'}),
    now: () => fixedNow,
  );
}

Matcher wordError(String message) =>
    throwsA(isA<WordException>().having((e) => e.message, 'message', message));

void main() {
  group('WordService.submitWord', () {
    test('saves the normalized word for the signed-in user', () async {
      final storage = FakeWordStorage();
      final service = buildService(storage: storage);

      final saved = await service.submitWord('  Apple ');

      expect(saved, 'apple');
      expect(storage.saves, [('abc', 'apple')]);
    });

    test('rejects a player who is not signed in', () async {
      final storage = FakeWordStorage();
      final service = buildService(storage: storage, auth: FakeAuthService());

      await expectLater(
        service.submitWord('apple'),
        wordError('You need to be signed in to add a word.'),
      );
      expect(storage.saves, isEmpty);
    });

    test('rejects a word with a bad shape without saving', () async {
      final storage = FakeWordStorage();
      final service = buildService(storage: storage);

      await expectLater(
        service.submitWord('a1'),
        wordError('Use letters A-Z only (no spaces, numbers or symbols)'),
      );
      expect(storage.saves, isEmpty);
    });

    test(
      'rejects a player still on cooldown, before loading the dictionary',
      () async {
        final storage = FakeWordStorage(
          lastSubmission: fixedNow.subtract(const Duration(hours: 2)),
        );
        final service = buildService(
          storage: storage,
          loadDictionary: () async => throw StateError('should not be loaded'),
        );

        await expectLater(
          service.submitWord('apple'),
          wordError("You've already added a word. You can add another in 22h."),
        );
        expect(storage.saves, isEmpty);
      },
    );

    test('allows a new word once 25 hours have passed', () async {
      final storage = FakeWordStorage(
        lastSubmission: fixedNow.subtract(const Duration(hours: 25)),
      );
      final service = buildService(storage: storage);

      expect(await service.submitWord('apple'), 'apple');
      expect(storage.saves, [('abc', 'apple')]);
    });

    test('allows a new word exactly 24 hours later', () async {
      final storage = FakeWordStorage(
        lastSubmission: fixedNow.subtract(WordRules.cooldown),
      );
      final service = buildService(storage: storage);

      expect(await service.submitWord('house'), 'house');
    });

    test('rejects a word that is not in the dictionary', () async {
      final storage = FakeWordStorage();
      final service = buildService(storage: storage);

      await expectLater(
        service.submitWord('zzzzz'),
        wordError('"zzzzz" isn\'t in the dictionary. Try another word.'),
      );
      expect(storage.saves, isEmpty);
    });

    test('loads the dictionary only once', () async {
      var loads = 0;
      final service = buildService(
        storage: FakeWordStorage(),
        loadDictionary: () async {
          loads++;
          return WordDictionary({'apple', 'house'});
        },
      );

      await service.submitWord('apple');
      await service.submitWord('house');

      expect(loads, 1);
    });

    test('retries loading the dictionary after a failed load', () async {
      var loads = 0;
      final service = buildService(
        storage: FakeWordStorage(),
        loadDictionary: () async {
          loads++;
          if (loads == 1) throw StateError('asset missing');
          return WordDictionary({'apple'});
        },
      );

      await expectLater(service.submitWord('apple'), throwsStateError);
      expect(await service.submitWord('apple'), 'apple');
    });

    test('passes storage errors through', () async {
      final storage = FakeWordStorage()
        ..saveError = FirebaseException(
          plugin: 'cloud_firestore',
          code: 'permission-denied',
        );
      final service = buildService(storage: storage);

      await expectLater(
        service.submitWord('apple'),
        throwsA(isA<FirebaseException>()),
      );
    });
  });

  group('wordErrorMessage', () {
    test('uses the message of a WordException', () {
      expect(wordErrorMessage(const WordException('nope')), 'nope');
    });

    test('explains permission-denied as the 24 hour limit', () {
      expect(
        wordErrorMessage(
          FirebaseException(
            plugin: 'cloud_firestore',
            code: 'permission-denied',
          ),
        ),
        "Your word couldn't be saved. Remember: one word every 24 hours.",
      );
    });

    test('explains unavailable as a connection problem', () {
      expect(
        wordErrorMessage(
          FirebaseException(plugin: 'cloud_firestore', code: 'unavailable'),
        ),
        'No connection. Check your network and try again.',
      );
    });

    test('gives a generic message for other Firebase errors', () {
      expect(
        wordErrorMessage(
          FirebaseException(plugin: 'cloud_firestore', code: 'aborted'),
        ),
        'Could not save your word. Please try again.',
      );
    });

    test('gives a generic message for anything else', () {
      expect(
        wordErrorMessage(StateError('boom')),
        'Something went wrong. Please try again.',
      );
    });
  });
}
