import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

import 'helpers/test_helpers.dart';

void main() {
  group('Login', () {
    testWidgets('shows an AppBar titled Hang-Out!', (tester) async {
      await tester.pumpWidget(wrap(const Login()));

      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Hang-Out!'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows a Log In button', (tester) async {
      await tester.pumpWidget(wrap(const Login()));

      expect(find.byKey(const Key('Log In')), findsOneWidget);
      expect(find.text('Log In'), findsOneWidget);
    });

    testWidgets('has only one button', (tester) async {
      await tester.pumpWidget(wrap(const Login()));

      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Log In navigates to the MainMenu', (tester) async {
      await tester.pumpWidget(wrap(const Login()));

      await tester.tap(find.byKey(const Key('Log In')));
      await tester.pumpAndSettle();

      expect(find.byType(MainMenu), findsOneWidget);
      expect(find.text('Leaderboard'), findsOneWidget);
    });
  });
}
