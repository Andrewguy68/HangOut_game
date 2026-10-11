import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/Login_Pages/Login.dart';
import 'package:flutter_application_1/Main_Menu/main_menu.dart';
import 'package:flutter_application_1/auth_gate.dart';

import 'helpers/fake_auth_service.dart';
import 'helpers/test_helpers.dart';

void main() {
  group('AuthGate', () {
    testWidgets('shows a spinner until the first auth event arrives', (
      tester,
    ) async {
      final auth = FakeAuthService(deferInitialAuthEvent: true);
      await tester.pumpWidget(wrap(const AuthGate(), auth: auth));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(Login), findsNothing);
      expect(find.byType(MainMenu), findsNothing);

      auth.releaseInitialAuthEvent();
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(Login), findsOneWidget);
    });

    testWidgets('shows Login when nobody is signed in', (tester) async {
      await tester.pumpWidget(wrap(const AuthGate()));
      await tester.pumpAndSettle();

      expect(find.byType(Login), findsOneWidget);
      expect(find.byType(MainMenu), findsNothing);
    });

    testWidgets('shows MainMenu when a user is already signed in', (
      tester,
    ) async {
      final auth = FakeAuthService(signedInUser: FakeUser('abc'));
      await tester.pumpWidget(wrap(const AuthGate(), auth: auth));
      await tester.pumpAndSettle();

      expect(find.byType(MainMenu), findsOneWidget);
      expect(find.byType(Login), findsNothing);
    });

    testWidgets('switches to MainMenu when a user signs in', (tester) async {
      final auth = FakeAuthService();
      await tester.pumpWidget(wrap(const AuthGate(), auth: auth));
      await tester.pumpAndSettle();
      expect(find.byType(Login), findsOneWidget);

      await auth.logIn('ameksa', 'secret123');
      await tester.pumpAndSettle();

      expect(find.byType(MainMenu), findsOneWidget);
      expect(find.byType(Login), findsNothing);
    });

    testWidgets('switches back to Login when the user signs out', (
      tester,
    ) async {
      final auth = FakeAuthService(signedInUser: FakeUser('abc'));
      await tester.pumpWidget(wrap(const AuthGate(), auth: auth));
      await tester.pumpAndSettle();
      expect(find.byType(MainMenu), findsOneWidget);

      await auth.logOut();
      await tester.pumpAndSettle();

      expect(find.byType(Login), findsOneWidget);
      expect(find.byType(MainMenu), findsNothing);
    });
  });
}
