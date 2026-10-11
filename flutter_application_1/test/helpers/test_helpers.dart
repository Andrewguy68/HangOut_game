import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/auth_scope.dart';
import 'package:flutter_application_1/auth_service.dart';

import 'fake_auth_service.dart';

Widget wrap(Widget child, {AuthService? auth}) => AuthScope(
  service: auth ?? FakeAuthService(),
  child: MaterialApp(home: child),
);

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
