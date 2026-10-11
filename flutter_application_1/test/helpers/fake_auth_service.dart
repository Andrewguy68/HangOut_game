import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/auth_service.dart';

class FakeUser extends Fake implements User {
  FakeUser(this.uid);

  @override
  final String uid;
}

class FakeAuthService implements AuthService {
  FakeAuthService({User? signedInUser, bool deferInitialAuthEvent = false})
    : _current = signedInUser {
    if (!deferInitialAuthEvent) _initialEvent.complete();
  }

  User? _current;
  final _controller = StreamController<User?>.broadcast();
  final _initialEvent = Completer<void>();

  final List<(String, String)> logInCalls = [];
  final List<(String, String)> signUpCalls = [];
  int logOutCalls = 0;

  Object? logInError;
  Object? signUpError;

  Completer<void>? holdLogIn;
  Completer<void>? holdSignUp;

  void releaseInitialAuthEvent() {
    if (!_initialEvent.isCompleted) _initialEvent.complete();
  }

  @override
  Stream<User?> get authState async* {
    await _initialEvent.future;
    yield _current;
    yield* _controller.stream;
  }

  @override
  User? get currentUser => _current;

  @override
  Future<User> signUp(String username, String password) async {
    signUpCalls.add((username, password));
    await holdSignUp?.future;
    final error = signUpError;
    if (error != null) throw error;
    return _signIn(username);
  }

  @override
  Future<User> logIn(String username, String password) async {
    logInCalls.add((username, password));
    await holdLogIn?.future;
    final error = logInError;
    if (error != null) throw error;
    return _signIn(username);
  }

  @override
  Future<void> logOut() async {
    logOutCalls++;
    _current = null;
    _controller.add(null);
  }

  User _signIn(String username) {
    final user = FakeUser(username.trim().toLowerCase());
    _current = user;
    _controller.add(user);
    return user;
  }
}
