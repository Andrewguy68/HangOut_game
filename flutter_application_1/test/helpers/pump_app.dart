import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/Storage/word_service.dart';
import 'package:flutter_application_1/main.dart';

import 'fake_auth_service.dart';
import 'test_helpers.dart';

Future<FakeAuthService> pumpApp(
  WidgetTester tester, {
  FakeAuthService? auth,
  WordService? words,
}) async {
  useTallScreen(tester);
  final authService = auth ?? FakeAuthService();
  await tester.pumpWidget(
    MyApp(
      authService: authService,
      wordService: words ?? fakeWordService(auth: authService),
    ),
  );
  await tester.pumpAndSettle();
  return authService;
}
