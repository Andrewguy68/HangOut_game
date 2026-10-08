import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {  //Builds the main app widget
    return MaterialApp(
      title: 'Hang-Out!',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const Login(),
    );
  }
}

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
            buildNavButton(context, 'Log In', const MainMenu()),
          ],
        ),
      ),
    );
  }
}

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {  //builds the main menu widget
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildNavButton(context, 'Start Game', const GameTime()),
            buildNavButton(context, 'Back to Login', const Login()),
          ],
        ),
      ),
    );
  }
}


class GameTime extends StatefulWidget {
  const GameTime({super.key});

  @override
  State<GameTime> createState() => _GameTimeState();
}

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

class _GameTimeState extends State<GameTime> {
  @override
  Widget build(BuildContext context) {  //builds the main menu widget
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hang-Out!'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildNavButton(context, 'Back to Main Menu', const MainMenu()),
          ],
        ),
      ),
    );
  }
}

Widget buildNavButton(BuildContext context, String label, Widget destination) { // Builds a navigation button widget which creates all of the needed elevated buttons for this code.
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      }, key: Key(label),
      child: Text(label),
    ),
  );
}
