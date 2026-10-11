import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/Login_Pages/auth_form.dart';

import 'helpers/test_helpers.dart';

Future<void> pumpForm(
  WidgetTester tester, {
  required Future<void> Function(String, String) onSubmit,
  FormFieldValidator<String>? usernameValidator,
  FormFieldValidator<String>? passwordValidator,
}) {
  useTallScreen(tester);
  return tester.pumpWidget(
    wrap(
      Scaffold(
        body: SingleChildScrollView(
          child: AuthForm(
            submitLabel: 'Go',
            onSubmit: onSubmit,
            usernameValidator: usernameValidator,
            passwordValidator: passwordValidator,
            footer: const [Text('footer')],
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('AuthForm', () {
    testWidgets('shows Username and Password fields', (tester) async {
      await pumpForm(tester, onSubmit: (u, p) async {});

      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.widgetWithText(TextField, 'Username'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);
    });

    testWidgets('hides the password but not the username', (tester) async {
      await pumpForm(tester, onSubmit: (u, p) async {});

      final username = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Username'),
      );
      final password = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Password'),
      );
      expect(username.obscureText, isFalse);
      expect(password.obscureText, isTrue);
    });

    testWidgets('shows the submit button and the footer widgets', (
      tester,
    ) async {
      await pumpForm(tester, onSubmit: (u, p) async {});

      expect(find.byKey(const Key('Go')), findsOneWidget);
      expect(find.text('footer'), findsOneWidget);
    });

    testWidgets('calls onSubmit with the entered values', (tester) async {
      final calls = <(String, String)>[];
      await pumpForm(tester, onSubmit: (u, p) async => calls.add((u, p)));

      await typeCredentials(tester, 'ameksa', 'secret123');
      await tester.tap(find.byKey(const Key('Go')));
      await tester.pumpAndSettle();

      expect(calls, [('ameksa', 'secret123')]);
    });

    testWidgets('submits when the keyboard done action is pressed', (
      tester,
    ) async {
      final calls = <(String, String)>[];
      await pumpForm(tester, onSubmit: (u, p) async => calls.add((u, p)));

      await typeCredentials(tester, 'ameksa', 'secret123');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(calls, [('ameksa', 'secret123')]);
    });

    testWidgets('shows validator messages and does not submit', (tester) async {
      final calls = <(String, String)>[];
      await pumpForm(
        tester,
        onSubmit: (u, p) async => calls.add((u, p)),
        usernameValidator: (v) =>
            (v == null || v.isEmpty) ? 'username needed' : null,
        passwordValidator: (v) =>
            (v == null || v.isEmpty) ? 'password needed' : null,
      );

      await tester.tap(find.byKey(const Key('Go')));
      await tester.pumpAndSettle();

      expect(find.text('username needed'), findsOneWidget);
      expect(find.text('password needed'), findsOneWidget);
      expect(calls, isEmpty);
    });

    testWidgets('shows a friendly message when onSubmit throws an auth error', (
      tester,
    ) async {
      await pumpForm(
        tester,
        onSubmit: (u, p) async {
          throw FirebaseAuthException(code: 'wrong-password');
        },
      );

      await tester.tap(find.byKey(const Key('Go')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('auth-error')), findsOneWidget);
      expect(find.text('Incorrect username or password.'), findsOneWidget);
    });

    testWidgets('shows a generic message for unexpected errors', (
      tester,
    ) async {
      await pumpForm(
        tester,
        onSubmit: (u, p) async {
          throw StateError('boom');
        },
      );

      await tester.tap(find.byKey(const Key('Go')));
      await tester.pumpAndSettle();

      expect(
        find.text('Something went wrong. Please try again.'),
        findsOneWidget,
      );
    });

    testWidgets('clears the previous error on the next submit', (tester) async {
      var attempts = 0;
      await pumpForm(
        tester,
        onSubmit: (u, p) async {
          attempts++;
          if (attempts == 1)
            throw FirebaseAuthException(code: 'wrong-password');
        },
      );

      await tester.tap(find.byKey(const Key('Go')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('auth-error')), findsOneWidget);

      await tester.tap(find.byKey(const Key('Go')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('auth-error')), findsNothing);
    });

    testWidgets('disables the button and shows a spinner while submitting', (
      tester,
    ) async {
      final pending = Completer<void>();
      await pumpForm(tester, onSubmit: (u, p) => pending.future);

      await tester.tap(find.byKey(const Key('Go')));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(
        tester.widget<ElevatedButton>(find.byKey(const Key('Go'))).onPressed,
        isNull,
      );

      pending.complete();
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(
        tester.widget<ElevatedButton>(find.byKey(const Key('Go'))).onPressed,
        isNotNull,
      );
    });
  });
}
