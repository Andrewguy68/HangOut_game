import 'package:flutter/widgets.dart';

import 'package:flutter_application_1/auth_service.dart';

/// makes one [AuthService} available to every page below it, so pages never
/// create their own (which also lets tests swap in a fake).
class AuthScope extends InheritedWidget {
  const AuthScope({super.key, required this.service, required super.child});

  final AuthService service;

  static AuthService of(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AuthScope>();
    assert(scope != null, 'No AuthScope found. Wrap your app in an AuthScope.');
    return scope!.service;
  }

  @override
  bool updateShouldNotify(AuthScope oldWidget) => service != oldWidget.service;
}
