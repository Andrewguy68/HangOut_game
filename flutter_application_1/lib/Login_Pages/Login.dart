import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';

import 'package:flutter_application_1/Login_Pages/auth_form.dart';
import 'package:flutter_application_1/Main_Menu/main_menu.dart';
import 'package:flutter_application_1/Widget_Setup/widgit_build.dart';
import 'package:flutter_application_1/auth_scope.dart';
import 'package:flutter_application_1/validators.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(100.0),
          child: AuthForm(
            submitLabel: 'Log In',
            usernameValidator: Validators.loginUsername,
            passwordValidator: Validators.loginPassword,
            // No navigation needed on success: AuthGate swaps this page for
            // the MainMenu as soon as the signed-in user arrives.
            onSubmit: (username, password) =>
                AuthScope.of(context).logIn(username, password),
            footer: [
              NavStart().buildNavButton(context, 'Sign Up', const Signup()),
              if (kDebugMode)
                NavStart().buildNavButton(
                  context,
                  'Bypass Login',
                  const MainMenu(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(100.0),
          child: AuthForm(
            submitLabel: 'Sign Up',
            usernameValidator: Validators.signupUsername,
            passwordValidator: Validators.signupPassword,
            onSubmit: (username, password) async {
              await AuthScope.of(context).signUp(username, password);
              // Signing up signs the user in, so AuthGate now shows the
              // MainMenu underneath this page. Drop this page to reveal it.
              if (!context.mounted) return;
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ),
      ),
    );
  }
}
