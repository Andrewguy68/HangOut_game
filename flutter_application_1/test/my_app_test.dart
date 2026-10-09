import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  group('MyApp', () {
    testWidgets('builds a MaterialApp titled Hang-Out!', (tester) async {
      await tester.pumpWidget(const MyApp());

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.title, 'Hang-Out!');
    });

    testWidgets('uses Material 3', (tester) async {
      await tester.pumpWidget(const MyApp());

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.theme!.useMaterial3, isTrue);
    });

    testWidgets('seeds the color scheme from orange', (tester) async {
      await tester.pumpWidget(const MyApp());

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      final expected = ColorScheme.fromSeed(seedColor: Colors.orange);
      expect(app.theme!.colorScheme.primary, expected.primary);
    });

    testWidgets('starts on the Login screen', (tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.byType(Login), findsOneWidget);
    });
  });
}
