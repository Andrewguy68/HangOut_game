import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

import 'helpers/test_helpers.dart';

void main() {
  group('MainMenu', () {
    testWidgets('shows an AppBar titled Leaderboard', (tester) async {
      await tester.pumpWidget(wrap(const MainMenu()));

      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Leaderboard'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows Start Game and Back to Login buttons', (tester) async {
      await tester.pumpWidget(wrap(const MainMenu()));

      expect(find.byKey(const Key('Start Game')), findsOneWidget);
      expect(find.byKey(const Key('Back to Login')), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNWidgets(2));
    });

    testWidgets('Start Game navigates to GameTime', (tester) async {
      await tester.pumpWidget(wrap(const MainMenu()));

      await tester.tap(find.byKey(const Key('Start Game')));
      await tester.pumpAndSettle();

      expect(find.byType(GameTime), findsOneWidget);
    });

    testWidgets('Back to Login navigates to Login', (tester) async {
      await tester.pumpWidget(wrap(const MainMenu()));

      await tester.tap(find.byKey(const Key('Back to Login')));
      await tester.pumpAndSettle();

      expect(find.byType(Login), findsOneWidget);
    });
  });
}
