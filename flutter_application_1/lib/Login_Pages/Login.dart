import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/Widget_Setup/widgit_build.dart';
import 'package:flutter_application_1/Main_Menu/main_menu.dart';



class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {  //Builds the login page widget
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hang-Out!'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NavStart().buildNavButton(context, 'Log In', const MainMenu()),
          ],
        ),
      ),
    );
  }
}

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {  //Builds the signup page widget
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hang-Out!'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NavStart().buildNavButton(context, 'Sign Up', const Login()),
          ],
        ),
      ),
    );
  }
}