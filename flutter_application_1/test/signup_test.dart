import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/Login_Pages/Login.dart';

import 'helpers/fake_auth_service.dart';
import 'helpers/test_helpers.dart';

void main() {
  group('Signup', () {
    testWidgets('shows an AppBar titled Sign Up', (tester) async {
      useTallScreen(tester);
      await tester.pumpWidget(wrap(const Signup()));

      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Sign Up'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows Username and Password fields', (tester) async {
      useTallScreen(tester);
      await tester.pumpWidget(wrap(const Signup()));

      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.widgetWithText(TextField, 'Username'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);
    });

    testWidgets('hides the password while typing', (tester) async {
      useTallScreen(tester);
      await tester.pumpWidget(wrap(const Signup()));

      final password = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Password'),
      );
      expect(password.obscureText, isTrue);
    });

    testWidgets('shows a single Sign Up button', (tester) async {
      useTallScreen(tester);
      await tester.pumpWidget(wrap(const Signup()));

      expect(find.byKey(const Key('Sign Up')), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('empty fields show messages and do not call signUp', (
      tester,
    ) async {
      useTallScreen(tester);
      final auth = FakeAuthService();
      await tester.pumpWidget(wrap(const Signup(), auth: auth));

      await tester.tap(find.byKey(const Key('Sign Up')));
      await tester.pumpAndSettle();

      expect(find.text('Choose a username'), findsOneWidget);
      expect(find.text('Choose a password'), findsOneWidget);
      expect(auth.signUpCalls, isEmpty);
    });

    testWidgets('rejects a username with invalid characters', (tester) async {
      useTallScreen(tester);
      final auth = FakeAuthService();
      await tester.pumpWidget(wrap(const Signup(), auth: auth));

      await typeCredentials(tester, 'bad name!', 'secret123');
      await tester.tap(find.byKey(const Key('Sign Up')));
      await tester.pumpAndSettle();

      expect(
        find.text('Use only letters, numbers and underscores'),
        findsOneWidget,
      );
      expect(auth.signUpCalls, isEmpty);
    });

    testWidgets('rejects a password shorter than 6 characters', (tester) async {
      useTallScreen(tester);
      final auth = FakeAuthService();
      await tester.pumpWidget(wrap(const Signup(), auth: auth));

      await typeCredentials(tester, 'ameksa', 'abc');
      await tester.tap(find.byKey(const Key('Sign Up')));
      await tester.pumpAndSettle();

      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
      expect(auth.signUpCalls, isEmpty);
    });

    testWidgets('passes valid credentials to AuthService.signUp', (
      tester,
    ) async {
      useTallScreen(tester);
      final auth = FakeAuthService();
      await tester.pumpWidget(wrap(const Signup(), auth: auth));

      await typeCredentials(tester, 'ameksa', 'secret123');
      await tester.tap(find.byKey(const Key('Sign Up')));
      await tester.pumpAndSettle();

      expect(auth.signUpCalls, [('ameksa', 'secret123')]);
    });

    testWidgets('shows a message when the username is already taken', (
      tester,
    ) async {
      useTallScreen(tester);
      final auth = FakeAuthService()
        ..signUpError = FirebaseAuthException(code: 'email-already-in-use');
      await tester.pumpWidget(wrap(const Signup(), auth: auth));

      await typeCredentials(tester, 'ameksa', 'secret123');
      await tester.tap(find.byKey(const Key('Sign Up')));
      await tester.pumpAndSettle();

      expect(find.text('That username is already taken.'), findsOneWidget);
    });
  });
}
