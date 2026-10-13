import 'package:flutter/widgets.dart';

import 'package:flutter_application_1/Storage/word_service.dart';

/// same idea as AuthScope
class WordScope extends InheritedWidget {
  const WordScope({super.key, required this.service, required super.child});

  final WordService service;

  static WordService of(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<WordScope>();
    assert(scope != null, 'No WordScope found. Wrap your app in a WordScope.');
    return scope!.service;
  }

  @override
  bool updateShouldNotify(WordScope oldWidget) => service != oldWidget.service;
}
