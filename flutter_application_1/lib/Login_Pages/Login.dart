import 'package:flutter/material.dart';
import 'package:flutter_application_1/Widget_Setup/widgit_build.dart';
import 'package:flutter_application_1/Main_Menu/main_menu.dart';
import 'package:flutter_application_1/auth_service.dart';



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
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
                labelStyle: TextStyle(fontSize: 20),
              ),
            ),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            NavStart().buildLogButton(context, 'Log In', const MainMenu()),
            NavStart().buildNavButton(context, 'Sign Up', const Signup()),


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
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            NavStart().buildSignButton(context, 'Sign Up', const Login()),
          ],
        ),
      ),
    );
  }
}