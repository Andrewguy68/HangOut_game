import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/Game_Time/game_page.dart';
import 'package:flutter_application_1/Main_Menu/main_menu.dart';

import 'helpers/test_helpers.dart';

void main() {
  group('GameTime', () {
    testWidgets('shows an AppBar titled Hang-Out!', (tester) async {
      await tester.pumpWidget(wrap(const GameTime()));

      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Hang-Out!'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows a Back to Main Menu button', (tester) async {
      await tester.pumpWidget(wrap(const GameTime()));

      expect(find.byKey(const Key('Back to Main Menu')), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Back to Main Menu navigates to MainMenu', (tester) async {
      await tester.pumpWidget(wrap(const GameTime()));

      await tester.tap(find.byKey(const Key('Back to Main Menu')));
      await tester.pumpAndSettle();

      expect(find.byType(MainMenu), findsOneWidget);
    });
  });
}
