import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/Game_Time/game_page.dart';
import 'package:flutter_application_1/Login_Pages/Login.dart';
import 'package:flutter_application_1/Main_Menu/main_menu.dart';

import 'helpers/pump_app.dart';

void main() {
  group('navigation flow', () {
    testWidgets('Login -> MainMenu -> GameTime -> MainMenu -> Login', (
      tester,
    ) async {
      final auth = await pumpApp(tester);

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
      expect(auth.logOutCalls, 1);
    });

    testWidgets('Login -> Signup', (tester) async {
      await pumpApp(tester);

      await tester.tap(find.byKey(const Key('Sign Up')));
      await tester.pumpAndSettle();

      expect(find.byType(Signup), findsOneWidget);
    });
  });
}
