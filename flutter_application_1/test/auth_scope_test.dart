import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/auth_scope.dart';
import 'package:flutter_application_1/auth_service.dart';

import 'helpers/fake_auth_service.dart';

void main() {
  group('AuthScope', () {
    testWidgets('of returns the service provided above', (tester) async {
      final auth = FakeAuthService();
      AuthService? found;

      await tester.pumpWidget(
        AuthScope(
          service: auth,
          child: Builder(
            builder: (context) {
              found = AuthScope.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(found, same(auth));
    });

    testWidgets('of asserts when there is no AuthScope above', (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            AuthScope.of(context);
            return const SizedBox();
          },
        ),
      );

      expect(tester.takeException(), isA<AssertionError>());
    });
  });
}
