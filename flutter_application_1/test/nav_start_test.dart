import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/Widget_Setup/widgit_build.dart';

import 'helpers/test_helpers.dart';

typedef ButtonBuilder = Widget Function(BuildContext, String, Widget);

/// mounts one NavStart button builder with the label 'Go'.
Future<void> pumpButton(WidgetTester tester, ButtonBuilder build) {
  return tester.pumpWidget(
    wrap(
      Scaffold(
        body: Builder(
          builder: (context) => build(context, 'Go', const TestDestination()),
        ),
      ),
    ),
  );
}

/// finds padding with the given vertical padding.
Finder paddedBy(double vertical) => find.byWidgetPredicate(
  (w) => w is Padding && w.padding == EdgeInsets.symmetric(vertical: vertical),
);

void main() {
  group('NavStart.buildNavButton', () {
    testWidgets('renders an ElevatedButton with the given label', (
      tester,
    ) async {
      await pumpButton(tester, NavStart().buildNavButton);

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Go'), findsOneWidget);
    });

    testWidgets('uses the label as the button key', (tester) async {
      await pumpButton(tester, NavStart().buildNavButton);

      expect(find.byKey(const Key('Go')), findsOneWidget);
    });

    testWidgets('wraps the button in 8px vertical padding', (tester) async {
      await pumpButton(tester, NavStart().buildNavButton);

      expect(
        find.ancestor(of: find.byType(ElevatedButton), matching: paddedBy(8)),
        findsOneWidget,
      );
    });

    testWidgets('pushes the destination when tapped', (tester) async {
      await pumpButton(tester, NavStart().buildNavButton);

      await tester.tap(find.byKey(const Key('Go')));
      await tester.pumpAndSettle();

      expect(find.text('destination reached'), findsOneWidget);
    });

    testWidgets('pushed destination can be popped to return', (tester) async {
      await pumpButton(tester, NavStart().buildNavButton);

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

  group('NavStart.buildLogButton', () {
    testWidgets('renders an ElevatedButton with the given label and key', (
      tester,
    ) async {
      await pumpButton(tester, NavStart().buildLogButton);

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Go'), findsOneWidget);
      expect(find.byKey(const Key('Go')), findsOneWidget);
    });

    testWidgets('wraps the button in 15px vertical padding', (tester) async {
      await pumpButton(tester, NavStart().buildLogButton);

      expect(
        find.ancestor(of: find.byType(ElevatedButton), matching: paddedBy(15)),
        findsOneWidget,
      );
    });
  });

  group('NavStart.buildSignButton', () {
    testWidgets('renders an ElevatedButton with the given label and key', (
      tester,
    ) async {
      await pumpButton(tester, NavStart().buildSignButton);

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Go'), findsOneWidget);
      expect(find.byKey(const Key('Go')), findsOneWidget);
    });

    testWidgets('wraps the button in 15px vertical padding', (tester) async {
      await pumpButton(tester, NavStart().buildSignButton);

      expect(
        find.ancestor(of: find.byType(ElevatedButton), matching: paddedBy(15)),
        findsOneWidget,
      );
    });
  });

  group('NavStart.rectangle', () {
    testWidgets('shows the numbered list 1 to 10', (tester) async {
      await tester.pumpWidget(
        wrap(Builder(builder: (context) => NavStart().rectangle(context))),
      );

      expect(
        find.text('1. \n2. \n3. \n4. \n5. \n6. \n7. \n8. \n9. \n10.'),
        findsOneWidget,
      );
    });

    testWidgets('draws a 2px black border with rounded corners', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(Builder(builder: (context) => NavStart().rectangle(context))),
      );

      final boxFinder = find.byWidgetPredicate((w) {
        if (w is! Container || w.decoration is! BoxDecoration) return false;
        final d = w.decoration as BoxDecoration;
        return d.border == Border.all(color: Colors.black, width: 2) &&
            d.borderRadius == BorderRadius.circular(10);
      });
      expect(boxFinder, findsOneWidget);
    });
  });
}
