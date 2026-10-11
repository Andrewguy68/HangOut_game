import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/Login_Pages/Login.dart';

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

    testWidgets('shows a single Sign Up button', (tester) async {
      useTallScreen(tester);
      await tester.pumpWidget(wrap(const Signup()));

      expect(find.byKey(const Key('Sign Up')), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('fields accept typed text', (tester) async {
      useTallScreen(tester);
      await tester.pumpWidget(wrap(const Signup()));

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
  });
}
