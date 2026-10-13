import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/Game_Time/game_page.dart';
import 'package:flutter_application_1/Main_Menu/add_word_dialog.dart';
import 'package:flutter_application_1/Main_Menu/main_menu.dart';

import 'helpers/fake_auth_service.dart';
import 'helpers/fake_word_storage.dart';
import 'helpers/test_helpers.dart';

void main() {
  group('MainMenu', () {
    testWidgets('shows an AppBar titled Hang-Out!', (tester) async {
      await tester.pumpWidget(wrap(const MainMenu()));

      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Hang-Out!'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows Start Game, Add Word and Sign Out buttons', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const MainMenu()));

      expect(find.byKey(const Key('Start Game')), findsOneWidget);
      expect(find.byKey(const Key('Add Word')), findsOneWidget);
      expect(find.byKey(const Key('Sign Out')), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNWidgets(3));
    });

    testWidgets('Start Game navigates to GameTime', (tester) async {
      await tester.pumpWidget(wrap(const MainMenu()));

      await tester.tap(find.byKey(const Key('Start Game')));
      await tester.pumpAndSettle();

      expect(find.byType(GameTime), findsOneWidget);
    });

    testWidgets('Sign Out logs the user out through AuthService', (
      tester,
    ) async {
      final auth = FakeAuthService(signedInUser: FakeUser('abc'));
      await tester.pumpWidget(wrap(const MainMenu(), auth: auth));

      await tester.tap(find.byKey(const Key('Sign Out')));
      await tester.pumpAndSettle();

      expect(auth.logOutCalls, 1);
      expect(auth.currentUser, isNull);
    });
  });

  group('MainMenu add word', () {
    testWidgets('Add Word opens the dialog', (tester) async {
      await tester.pumpWidget(wrap(const MainMenu()));

      await tester.tap(find.byKey(const Key('Add Word')));
      await tester.pumpAndSettle();

      expect(find.byType(AddWordDialog), findsOneWidget);
    });

    testWidgets('cancelling shows no confirmation', (tester) async {
      await tester.pumpWidget(wrap(const MainMenu()));

      await tester.tap(find.byKey(const Key('Add Word')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('Cancel')));
      await tester.pumpAndSettle();

      expect(find.byType(AddWordDialog), findsNothing);
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('saving a word closes the dialog and confirms it', (
      tester,
    ) async {
      final auth = FakeAuthService(signedInUser: FakeUser('abc'));
      final storage = FakeWordStorage();
      await tester.pumpWidget(
        wrap(
          const MainMenu(),
          auth: auth,
          words: fakeWordService(auth: auth, storage: storage),
        ),
      );

      await tester.tap(find.byKey(const Key('Add Word')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'apple');
      await tester.tap(find.byKey(const Key('Submit Word')));
      await tester.pumpAndSettle();

      expect(storage.saves, [('abc', 'apple')]);
      expect(find.byType(AddWordDialog), findsNothing);
      expect(
        find.text('"apple" saved! Other players can now play against it.'),
        findsOneWidget,
      );
    });

    testWidgets(
      'a rejected word keeps the dialog open and shows no confirmation',
      (tester) async {
        final auth = FakeAuthService(signedInUser: FakeUser('abc'));
        await tester.pumpWidget(
          wrap(
            const MainMenu(),
            auth: auth,
            words: fakeWordService(auth: auth),
          ),
        );

        await tester.tap(find.byKey(const Key('Add Word')));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), 'zzzzz');
        await tester.tap(find.byKey(const Key('Submit Word')));
        await tester.pumpAndSettle();

        expect(find.byType(AddWordDialog), findsOneWidget);
        expect(find.byType(SnackBar), findsNothing);
      },
    );
  });
}
