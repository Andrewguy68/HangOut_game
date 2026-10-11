import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// wraps widget in MaterialApp so Navigator, Theme and Scaffold work.
Widget wrap(Widget child) => MaterialApp(home: child);

/// gives the test tall logical screen (1200x2000) so padded layouts such as
/// login (100px padding on all sides) don't overflow the default 800x600.
void useTallScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(1200, 2000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

/// throwaway destination used to test navigation in isolation.
class TestDestination extends StatelessWidget {
  const TestDestination({super.key});

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Text('destination reached'));
}
