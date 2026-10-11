import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/Main_Menu/main_menu.dart';
import 'package:flutter_application_1/Game_Time/game_page.dart';
import 'package:flutter_application_1/Login_Pages/Login.dart';

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

    testWidgets('shows Start Game and Sign Out buttons', (tester) async {
      await tester.pumpWidget(wrap(const MainMenu()));

      expect(find.byKey(const Key('Start Game')), findsOneWidget);
      expect(find.byKey(const Key('Sign Out')), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNWidgets(2));
    });

    testWidgets('Start Game navigates to GameTime', (tester) async {
      await tester.pumpWidget(wrap(const MainMenu()));

      await tester.tap(find.byKey(const Key('Start Game')));
      await tester.pumpAndSettle();

      expect(find.byType(GameTime), findsOneWidget);
    });

    testWidgets('Sign Out navigates to Login', (tester) async {
      await tester.pumpWidget(wrap(const MainMenu()));

      await tester.tap(find.byKey(const Key('Sign Out')));
      await tester.pumpAndSettle();

      expect(find.byType(Login), findsOneWidget);
    });
  });
}
