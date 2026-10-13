import 'package:flutter/material.dart';
import 'package:flutter_application_1/Game_Time/game_logic.dart';
import 'package:flutter_application_1/Widget_Setup/widgit_build.dart';
import 'package:flutter_application_1/Main_Menu/main_menu.dart';
import 'package:flutter_application_1/auth_scope.dart';

class GameOver extends StatefulWidget {
  const GameOver({super.key});

  @override
  State<GameOver> createState() => _GameOverState();
}

// This class is the configuration for the state. It holds the values (in this
// case the title) provided by the parent (in this case the App widget) and
// used by the build method of the State. Fields in a Widget subclass are
// always marked "final".

class _GameOverState extends State<GameOver> {
  @override
  Widget build(BuildContext context) {
    //builds the main menu widget
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Game Over',
          style: Theme.of(context).textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Congrats! You Win!",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              "You Lose!",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              "Your word was:  WORD!",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            
            const SizedBox(height: 20),
            NavStart().buildNavButton(context, 'Back to Main Menu', const MainMenu()),  //this will check the letter and call the letter input function
            //NavStart().buildActionButton(context, 'Sign Out', _signOut), //this will check the word and call the solve function
          ],
        ),
      ),
    );
  }
}