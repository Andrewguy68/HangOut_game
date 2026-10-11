import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/Login_Pages/Login.dart';
import 'package:flutter_application_1/Main_Menu/main_menu.dart';

import 'helpers/fake_auth_service.dart';
import 'helpers/test_helpers.dart';

void main() {
  group('Login', () {
    testWidgets('shows an AppBar titled Log In', (tester) async {
      useTallScreen(tester);
      await tester.pumpWidget(wrap(const Login()));

      expect(
        find.descendant(of: find.byType(AppBar), matching: find.text('Log In')),
        findsOneWidget,
      );
    });

    testWidgets('shows Username and Password fields', (tester) async {
      useTallScreen(tester);
      await tester.pumpWidget(wrap(const Login()));

      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.widgetWithText(TextField, 'Username'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);
    });

    testWidgets('hides the password while typing', (tester) async {
      useTallScreen(tester);
      await tester.pumpWidget(wrap(const Login()));

      final password = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Password'),
      );
      expect(password.obscureText, isTrue);
    });

    testWidgets('shows Log In, Sign Up and Bypass Login buttons', (
      tester,
    ) async {
      useTallScreen(tester);
      await tester.pumpWidget(wrap(const Login()));

      expect(find.byKey(const Key('Log In')), findsOneWidget);
      expect(find.byKey(const Key('Sign Up')), findsOneWidget);
      expect(find.byKey(const Key('Bypass Login')), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNWidgets(3));
    });

    testWidgets('empty fields show messages and do not call logIn', (
      tester,
    ) async {
      useTallScreen(tester);
      final auth = FakeAuthService();
      await tester.pumpWidget(wrap(const Login(), auth: auth));

      await tester.tap(find.byKey(const Key('Log In')));
      await tester.pumpAndSettle();

      expect(find.text('Enter your username'), findsOneWidget);
      expect(find.text('Enter your password'), findsOneWidget);
      expect(auth.logInCalls, isEmpty);
    });

    testWidgets('passes the typed credentials to AuthService.logIn', (
      tester,
    ) async {
      useTallScreen(tester);
      final auth = FakeAuthService();
      await tester.pumpWidget(wrap(const Login(), auth: auth));

      await typeCredentials(tester, 'ameksa', 'secret123');
      await tester.tap(find.byKey(const Key('Log In')));
      await tester.pumpAndSettle();

      expect(auth.logInCalls, [('ameksa', 'secret123')]);
    });

    testWidgets('shows a friendly message when logIn fails', (tester) async {
      useTallScreen(tester);
      final auth = FakeAuthService()
        ..logInError = FirebaseAuthException(code: 'wrong-password');
      await tester.pumpWidget(wrap(const Login(), auth: auth));

      await typeCredentials(tester, 'ameksa', 'nope-nope');
      await tester.tap(find.byKey(const Key('Log In')));
      await tester.pumpAndSettle();

      expect(find.text('Incorrect username or password.'), findsOneWidget);
    });

    testWidgets('Sign Up navigates to the Signup page', (tester) async {
      useTallScreen(tester);
      await tester.pumpWidget(wrap(const Login()));

      await tester.tap(find.byKey(const Key('Sign Up')));
      await tester.pumpAndSettle();

      expect(find.byType(Signup), findsOneWidget);
    });

    testWidgets('Bypass Login navigates to the MainMenu', (tester) async {
      useTallScreen(tester);
      await tester.pumpWidget(wrap(const Login()));

      await tester.tap(find.byKey(const Key('Bypass Login')));
      await tester.pumpAndSettle();

      expect(find.byType(MainMenu), findsOneWidget);
    });
  });
}
