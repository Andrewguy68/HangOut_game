import 'package:flutter/material.dart';

/// wrap widget in MaterialApp so Navigator, Theme and Scaffold work.
Widget wrap(Widget child) => MaterialApp(home: child);

/// throwaway destination used to test navigation in isolation.
class TestDestination extends StatelessWidget {
  const TestDestination({super.key});

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Text('destination reached'));
}
