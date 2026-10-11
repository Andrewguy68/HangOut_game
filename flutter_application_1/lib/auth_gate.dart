import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

import 'package:flutter_application_1/Login_Pages/Login.dart';
import 'package:flutter_application_1/Main_Menu/main_menu.dart';
import 'package:flutter_application_1/auth_scope.dart';

/// mainMenu when a user is signed in, Login otherwise. It also reacts when the state changes, so a
/// successful log in / sign up / sign out swaps the page without any manual
/// navigation, and a saved session survives app restarts.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  // created once so rebuilds don't re-subscribe to Firebase.
  late final Stream<User?> _authState;

  @override
  void initState() {
    super.initState();
    _authState = AuthScope.of(context).authState;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authState,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snapshot.data == null ? const Login() : const MainMenu();
      },
    );
  }
}
