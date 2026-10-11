import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

import 'helpers/test_helpers.dart';

Future<void> pumpNavButton(WidgetTester tester) {
  return tester.pumpWidget(
    wrap(
      Scaffold(
        body: Builder(
          builder: (context) =>
              buildNavButton(context, 'Go', const TestDestination()),
        ),
      ),
    ),
  );
}

void main() {
  group('buildNavButton', () {
    testWidgets('renders an ElevatedButton with the given label', (
      tester,
    ) async {
      await pumpNavButton(tester);

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Go'), findsOneWidget);
    });

    testWidgets('uses the label as the button key', (tester) async {
      await pumpNavButton(tester);

      expect(find.byKey(const Key('Go')), findsOneWidget);
    });

    testWidgets('wraps the button in 8px vertical padding', (tester) async {
      await pumpNavButton(tester);

      final paddingFinder = find.byWidgetPredicate(
        (w) =>
            w is Padding &&
            w.padding == const EdgeInsets.symmetric(vertical: 8.0),
      );
      expect(
        find.ancestor(of: find.byType(ElevatedButton), matching: paddingFinder),
        findsOneWidget,
      );
    });

    testWidgets('pushes the destination when tapped', (tester) async {
      await pumpNavButton(tester);

      await tester.tap(find.byKey(const Key('Go')));
      await tester.pumpAndSettle();

      expect(find.text('destination reached'), findsOneWidget);
    });

    testWidgets('pushed destination can be popped to return', (tester) async {
      await pumpNavButton(tester);

      await tester.tap(find.byKey(const Key('Go')));
      await tester.pumpAndSettle();
      expect(find.text('destination reached'), findsOneWidget);

      final NavigatorState nav = tester.state(find.byType(Navigator));
      nav.pop();
      await tester.pumpAndSettle();

      expect(find.text('destination reached'), findsNothing);
      expect(find.text('Go'), findsOneWidget);
    });
  });
}
