import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/Main_Menu/add_word_dialog.dart';

import 'helpers/fake_auth_service.dart';
import 'helpers/fake_word_storage.dart';
import 'helpers/test_helpers.dart';

final fixedNow = DateTime(2026, 10, 12, 12);

class _Opener extends StatelessWidget {
  const _Opener({required this.onResult});

  final void Function(String?) onResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          key: const Key('open'),
          onPressed: () async => onResult(await showAddWordDialog(context)),
          child: const Text('open'),
        ),
      ),
    );
  }
}

Future<({FakeWordStorage storage, List<String?> results})> openDialog(
  WidgetTester tester, {
  FakeWordStorage? storage,
  FakeAuthService? auth,
}) async {
  final fakeStorage = storage ?? FakeWordStorage();
  final fakeAuth = auth ?? FakeAuthService(signedInUser: FakeUser('abc'));
  final results = <String?>[];

  await tester.pumpWidget(
    wrap(
      _Opener(onResult: results.add),
      auth: fakeAuth,
      words: fakeWordService(
        auth: fakeAuth,
        storage: fakeStorage,
        clock: () => fixedNow,
      ),
    ),
  );
  await tester.tap(find.byKey(const Key('open')));
  await tester.pumpAndSettle();

  return (storage: fakeStorage, results: results);
}

Future<void> submit(WidgetTester tester, String text) async {
  await tester.enterText(find.byType(TextField), text);
  await tester.tap(find.byKey(const Key('Submit Word')));
  await tester.pumpAndSettle();
}

void main() {
  group('AddWordDialog', () {
    testWidgets('shows the title, the field and both buttons', (tester) async {
      await openDialog(tester);

      expect(find.text('Add your word'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Your word'), findsOneWidget);
      expect(find.byKey(const Key('Submit Word')), findsOneWidget);
      expect(find.byKey(const Key('Cancel')), findsOneWidget);
    });

    testWidgets('Cancel closes the dialog and returns null', (tester) async {
      final opened = await openDialog(tester);

      await tester.tap(find.byKey(const Key('Cancel')));
      await tester.pumpAndSettle();

      expect(find.byType(AddWordDialog), findsNothing);
      expect(opened.results, [null]);
      expect(opened.storage.saves, isEmpty);
    });

    testWidgets('an empty word shows a message and saves nothing', (
      tester,
    ) async {
      final opened = await openDialog(tester);

      await tester.tap(find.byKey(const Key('Submit Word')));
      await tester.pumpAndSettle();

      expect(find.text('Enter a word'), findsOneWidget);
      expect(find.byType(AddWordDialog), findsOneWidget);
      expect(opened.storage.saves, isEmpty);
    });

    testWidgets('a word with symbols shows the letters-only message', (
      tester,
    ) async {
      final opened = await openDialog(tester);

      await submit(tester, 'app1e');

      expect(
        find.text('Use letters A-Z only (no spaces, numbers or symbols)'),
        findsOneWidget,
      );
      expect(opened.storage.saves, isEmpty);
    });

    testWidgets('a made-up word shows the dictionary message', (tester) async {
      final opened = await openDialog(tester);

      await submit(tester, 'zzzzz');

      expect(
        find.text('"zzzzz" isn\'t in the dictionary. Try another word.'),
        findsOneWidget,
      );
      expect(find.byType(AddWordDialog), findsOneWidget);
      expect(opened.storage.saves, isEmpty);
    });

    testWidgets('a player on cooldown sees how long to wait', (tester) async {
      final storage = FakeWordStorage(
        lastSubmission: fixedNow.subtract(const Duration(hours: 2)),
      );
      final opened = await openDialog(tester, storage: storage);

      await submit(tester, 'apple');

      expect(
        find.text("You've already added a word. You can add another in 22h."),
        findsOneWidget,
      );
      expect(opened.storage.saves, isEmpty);
    });

    testWidgets('a signed-out player is told to sign in', (tester) async {
      final opened = await openDialog(tester, auth: FakeAuthService());

      await submit(tester, 'apple');

      expect(
        find.text('You need to be signed in to add a word.'),
        findsOneWidget,
      );
      expect(opened.storage.saves, isEmpty);
    });

    testWidgets('a valid word is saved and the dialog returns it', (
      tester,
    ) async {
      final opened = await openDialog(tester);

      await submit(tester, '  Apple ');

      expect(opened.storage.saves, [('abc', 'apple')]);
      expect(find.byType(AddWordDialog), findsNothing);
      expect(opened.results, ['apple']);
    });

    testWidgets('submits when the keyboard done action is pressed', (
      tester,
    ) async {
      final opened = await openDialog(tester);

      await tester.enterText(find.byType(TextField), 'house');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(opened.storage.saves, [('abc', 'house')]);
      expect(opened.results, ['house']);
    });

    testWidgets('shows a friendly message when saving is refused', (
      tester,
    ) async {
      final storage = FakeWordStorage()
        ..saveError = FirebaseException(
          plugin: 'cloud_firestore',
          code: 'permission-denied',
        );
      await openDialog(tester, storage: storage);

      await submit(tester, 'apple');

      expect(
        find.text(
          "Your word couldn't be saved. Remember: one word every 24 hours.",
        ),
        findsOneWidget,
      );
      expect(find.byType(AddWordDialog), findsOneWidget);
    });

    testWidgets('clears the previous error on the next submit', (tester) async {
      await openDialog(tester);

      await submit(tester, 'zzzzz');
      expect(find.textContaining("isn't in the dictionary"), findsOneWidget);

      await submit(tester, 'apple');
      expect(find.textContaining("isn't in the dictionary"), findsNothing);
    });

    testWidgets('disables the buttons and shows a spinner while saving', (
      tester,
    ) async {
      final pending = Completer<void>();
      final storage = FakeWordStorage()..holdSave = pending;
      final opened = await openDialog(tester, storage: storage);

      await tester.enterText(find.byType(TextField), 'apple');
      await tester.tap(find.byKey(const Key('Submit Word')));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(
        tester
            .widget<ElevatedButton>(find.byKey(const Key('Submit Word')))
            .onPressed,
        isNull,
      );
      expect(
        tester.widget<TextButton>(find.byKey(const Key('Cancel'))).onPressed,
        isNull,
      );

      pending.complete();
      await tester.pumpAndSettle();

      expect(find.byType(AddWordDialog), findsNothing);
      expect(opened.results, ['apple']);
    });
  });
}
