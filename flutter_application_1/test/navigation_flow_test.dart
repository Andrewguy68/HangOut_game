import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/Login_Pages/Login.dart';
import 'package:flutter_application_1/Main_Menu/main_menu.dart';
import 'package:flutter_application_1/Game_Time/game_page.dart';

import 'helpers/test_helpers.dart';

void main() {
  group('navigation flow', () {
    testWidgets('Login -> MainMenu -> GameTime -> MainMenu -> Login', (
      tester,
    ) async {
      useTallScreen(tester);
      await tester.pumpWidget(const MyApp());

      await tester.tap(find.byKey(const Key('Bypass Login')));
      await tester.pumpAndSettle();
      expect(find.byType(MainMenu), findsOneWidget);

      await tester.tap(find.byKey(const Key('Start Game')));
      await tester.pumpAndSettle();
      expect(find.byType(GameTime), findsOneWidget);

      await tester.tap(find.byKey(const Key('Back to Main Menu')));
      await tester.pumpAndSettle();
      expect(find.byType(MainMenu), findsOneWidget);

      await tester.tap(find.byKey(const Key('Sign Out')));
      await tester.pumpAndSettle();
      expect(find.byType(Login), findsOneWidget);
    });

    testWidgets('Login -> Signup', (tester) async {
      useTallScreen(tester);
      await tester.pumpWidget(const MyApp());

      await tester.tap(find.byKey(const Key('Sign Up')));
      await tester.pumpAndSettle();

      expect(find.byType(Signup), findsOneWidget);
    });
  });
}
