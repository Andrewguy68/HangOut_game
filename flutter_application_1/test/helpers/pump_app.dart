import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

import 'fake_auth_service.dart';
import 'test_helpers.dart';

Future<FakeAuthService> pumpApp(
  WidgetTester tester, {
  FakeAuthService? auth,
}) async {
  useTallScreen(tester);
  final service = auth ?? FakeAuthService();
  await tester.pumpWidget(MyApp(authService: service));
  await tester.pumpAndSettle();
  return service;
}
