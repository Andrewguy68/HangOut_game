import 'package:flutter/material.dart';
import 'package:flutter_application_1/Game_Time/game_logic.dart';
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
  Widget build(BuildContext context) {
    //builds the main menu widget
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category and Opponent'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GameLogic(),
            //TextField(
                //decoration: const InputDecoration(
                  //border: OutlineInputBorder(),
                  //labelText: 'Enter a Letter',
                  //labelStyle: TextStyle(fontSize: 20),
                //),
              //),
            //NavStart().letterInput(context, 'Add a Letter', const MainMenu()),  //this will check the letter and call the letter input function
            //NavStart().Solve(context, 'Solve', const MainMenu())  //this will check the word and call the solve function
          ],
        ),
      ),
    );
  }
}
