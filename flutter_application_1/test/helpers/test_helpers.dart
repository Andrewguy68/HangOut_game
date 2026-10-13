import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/Storage/word_dictionary.dart';
import 'package:flutter_application_1/Storage/word_scope.dart';
import 'package:flutter_application_1/Storage/word_service.dart';
import 'package:flutter_application_1/auth_scope.dart';
import 'package:flutter_application_1/auth_service.dart';

import 'fake_auth_service.dart';
import 'fake_word_storage.dart';

WordService fakeWordService({
  required AuthService auth,
  FakeWordStorage? storage,
  Iterable<String> words = const ['apple', 'house', 'stone'],
  DateTime Function()? clock,
}) {
  return WordService(
    storage: storage ?? FakeWordStorage(),
    auth: auth,
    loadDictionary: () async => WordDictionary(words.toSet()),
    now: clock,
  );
}

Widget wrap(Widget child, {AuthService? auth, WordService? words}) {
  final authService = auth ?? FakeAuthService();
  return AuthScope(
    service: authService,
    child: WordScope(
      service: words ?? fakeWordService(auth: authService),
      child: MaterialApp(home: child),
    ),
  );
}

/// Gives the test a tall logical screen (1200x2000) so the padded auth pages
/// have room for every widget and taps always hit.
void useTallScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(1200, 2000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

Future<void> typeCredentials(
  WidgetTester tester,
  String username,
  String password,
) async {
  await tester.enterText(find.widgetWithText(TextField, 'Username'), username);
  await tester.enterText(find.widgetWithText(TextField, 'Password'), password);
}

class TestDestination extends StatelessWidget {
  const TestDestination({super.key});

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Text('destination reached'));
}
