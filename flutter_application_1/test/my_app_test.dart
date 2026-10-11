import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/Login_Pages/Login.dart';
import 'package:flutter_application_1/Main_Menu/main_menu.dart';
import 'package:flutter_application_1/auth_scope.dart';
import 'package:flutter_application_1/main.dart';

import 'helpers/fake_auth_service.dart';

void main() {
  group('MyApp', () {
    testWidgets('builds a MaterialApp titled Hang-Out!', (tester) async {
      await tester.pumpWidget(MyApp(authService: FakeAuthService()));

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.title, 'Hang-Out!');
    });

    testWidgets('uses Material 3', (tester) async {
      await tester.pumpWidget(MyApp(authService: FakeAuthService()));

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.theme!.useMaterial3, isTrue);
    });

    testWidgets('seeds the color scheme from orange', (tester) async {
      await tester.pumpWidget(MyApp(authService: FakeAuthService()));

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      final expected = ColorScheme.fromSeed(seedColor: Colors.orange);
      expect(app.theme!.colorScheme.primary, expected.primary);
    });

    testWidgets('starts on the Login screen when signed out', (tester) async {
      await tester.pumpWidget(MyApp(authService: FakeAuthService()));
      await tester.pumpAndSettle();

      expect(find.byType(Login), findsOneWidget);
    });

    testWidgets('starts on the MainMenu when already signed in', (
      tester,
    ) async {
      final auth = FakeAuthService(signedInUser: FakeUser('abc'));
      await tester.pumpWidget(MyApp(authService: auth));
      await tester.pumpAndSettle();

      expect(find.byType(MainMenu), findsOneWidget);
      expect(find.byType(Login), findsNothing);
    });

    testWidgets('provides the given AuthService to its pages', (tester) async {
      final auth = FakeAuthService();
      await tester.pumpWidget(MyApp(authService: auth));
      await tester.pumpAndSettle();

      final loginContext = tester.element(find.byType(Login));
      expect(AuthScope.of(loginContext), same(auth));
    });
  });
}
