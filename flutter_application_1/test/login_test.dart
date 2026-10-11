import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/Login_Pages/Login.dart';
import 'package:flutter_application_1/Main_Menu/main_menu.dart';

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

    testWidgets('fields accept typed text', (tester) async {
      useTallScreen(tester);
      await tester.pumpWidget(wrap(const Login()));

      await tester.enterText(
        find.widgetWithText(TextField, 'Username'),
        'ameksa',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Password'),
        'secret123',
      );

      expect(find.text('ameksa'), findsOneWidget);
      expect(find.text('secret123'), findsOneWidget);
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
