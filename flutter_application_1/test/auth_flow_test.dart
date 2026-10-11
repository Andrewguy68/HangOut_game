import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/Game_Time/game_page.dart';
import 'package:flutter_application_1/Login_Pages/Login.dart';
import 'package:flutter_application_1/Main_Menu/main_menu.dart';

import 'helpers/fake_auth_service.dart';
import 'helpers/pump_app.dart';
import 'helpers/test_helpers.dart';

// end-to-end through the real widgets (MyApp -> AuthGate -> pages) with fake
// AuthService, so no Firebase is involved.
void main() {
  group('auth flow', () {
    testWidgets('logging in lands on the MainMenu', (tester) async {
      final auth = await pumpApp(tester);

      await typeCredentials(tester, 'ameksa', 'secret123');
      await tester.tap(find.byKey(const Key('Log In')));
      await tester.pumpAndSettle();

      expect(auth.logInCalls, [('ameksa', 'secret123')]);
      expect(find.byType(MainMenu), findsOneWidget);
      expect(find.byType(Login), findsNothing);
    });

    testWidgets('a wrong password shows an error and stays on Login', (
      tester,
    ) async {
      final auth = FakeAuthService()
        ..logInError = FirebaseAuthException(code: 'wrong-password');
      await pumpApp(tester, auth: auth);

      await typeCredentials(tester, 'ameksa', 'nope-nope');
      await tester.tap(find.byKey(const Key('Log In')));
      await tester.pumpAndSettle();

      expect(find.text('Incorrect username or password.'), findsOneWidget);
      expect(find.byType(Login), findsOneWidget);
      expect(find.byType(MainMenu), findsNothing);
    });

    testWidgets('signing up lands on the MainMenu and closes the Signup page', (
      tester,
    ) async {
      final auth = await pumpApp(tester);

      await tester.tap(find.byKey(const Key('Sign Up')));
      await tester.pumpAndSettle();
      expect(find.byType(Signup), findsOneWidget);

      await typeCredentials(tester, 'ameksa', 'secret123');
      await tester.tap(find.byKey(const Key('Sign Up')));
      await tester.pumpAndSettle();

      expect(auth.signUpCalls, [('ameksa', 'secret123')]);
      expect(find.byType(MainMenu), findsOneWidget);
      expect(find.byType(Signup), findsNothing);
    });

    testWidgets('a taken username shows an error and stays on Signup', (
      tester,
    ) async {
      final auth = FakeAuthService()
        ..signUpError = FirebaseAuthException(code: 'email-already-in-use');
      await pumpApp(tester, auth: auth);

      await tester.tap(find.byKey(const Key('Sign Up')));
      await tester.pumpAndSettle();
      await typeCredentials(tester, 'ameksa', 'secret123');
      await tester.tap(find.byKey(const Key('Sign Up')));
      await tester.pumpAndSettle();

      expect(find.text('That username is already taken.'), findsOneWidget);
      expect(find.byType(Signup), findsOneWidget);
      expect(find.byType(MainMenu), findsNothing);
    });

    testWidgets('signing out returns to Login', (tester) async {
      final auth = await pumpApp(
        tester,
        auth: FakeAuthService(signedInUser: FakeUser('abc')),
      );
      expect(find.byType(MainMenu), findsOneWidget);

      await tester.tap(find.byKey(const Key('Sign Out')));
      await tester.pumpAndSettle();

      expect(auth.logOutCalls, 1);
      expect(find.byType(Login), findsOneWidget);
      expect(find.byType(MainMenu), findsNothing);
    });

    testWidgets('signing out from a nested MainMenu clears the page stack', (
      tester,
    ) async {
      await pumpApp(
        tester,
        auth: FakeAuthService(signedInUser: FakeUser('abc')),
      );

      await tester.tap(find.byKey(const Key('Start Game')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('Back to Main Menu')));
      await tester.pumpAndSettle();
      expect(find.byType(MainMenu), findsOneWidget);

      await tester.tap(find.byKey(const Key('Sign Out')));
      await tester.pumpAndSettle();

      expect(find.byType(Login), findsOneWidget);
      expect(find.byType(GameTime), findsNothing);
      expect(find.byType(MainMenu), findsNothing);
    });
  });
}
