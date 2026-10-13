import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/Login_Pages/Login.dart';
import 'package:flutter_application_1/Main_Menu/main_menu.dart';
import 'package:flutter_application_1/Storage/word_scope.dart';
import 'package:flutter_application_1/Storage/word_service.dart';
import 'package:flutter_application_1/auth_scope.dart';
import 'package:flutter_application_1/main.dart';

import 'helpers/fake_auth_service.dart';
import 'helpers/test_helpers.dart';

MyApp buildApp(FakeAuthService auth, {WordService? words}) => MyApp(
  authService: auth,
  wordService: words ?? fakeWordService(auth: auth),
);

void main() {
  group('MyApp', () {
    testWidgets('builds a MaterialApp titled Hang-Out!', (tester) async {
      await tester.pumpWidget(buildApp(FakeAuthService()));

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.title, 'Hang-Out!');
    });

    testWidgets('uses Material 3', (tester) async {
      await tester.pumpWidget(buildApp(FakeAuthService()));

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.theme!.useMaterial3, isTrue);
    });

    testWidgets('seeds the color scheme from orange', (tester) async {
      await tester.pumpWidget(buildApp(FakeAuthService()));

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      final expected = ColorScheme.fromSeed(seedColor: Colors.orange);
      expect(app.theme!.colorScheme.primary, expected.primary);
    });

    testWidgets('starts on the Login screen when signed out', (tester) async {
      await tester.pumpWidget(buildApp(FakeAuthService()));
      await tester.pumpAndSettle();

      expect(find.byType(Login), findsOneWidget);
    });

    testWidgets('starts on the MainMenu when already signed in', (
      tester,
    ) async {
      final auth = FakeAuthService(signedInUser: FakeUser('abc'));
      await tester.pumpWidget(buildApp(auth));
      await tester.pumpAndSettle();

      expect(find.byType(MainMenu), findsOneWidget);
      expect(find.byType(Login), findsNothing);
    });

    testWidgets('provides the given AuthService to its pages', (tester) async {
      final auth = FakeAuthService();
      await tester.pumpWidget(buildApp(auth));
      await tester.pumpAndSettle();

      final loginContext = tester.element(find.byType(Login));
      expect(AuthScope.of(loginContext), same(auth));
    });

    testWidgets('provides the given WordService to its pages', (tester) async {
      final auth = FakeAuthService();
      final words = fakeWordService(auth: auth);
      await tester.pumpWidget(buildApp(auth, words: words));
      await tester.pumpAndSettle();

      final loginContext = tester.element(find.byType(Login));
      expect(WordScope.of(loginContext), same(words));
    });
  });
}
