import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/Widget_Setup/widgit_build.dart';
import 'package:flutter_application_1/Main_Menu/main_menu.dart';

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
            NavStart().buildNavButton(context, 'Back to Main Menu', const MainMenu()),
          ],
        ),
      ),
    );
  }
}
