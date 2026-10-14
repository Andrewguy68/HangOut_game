import 'package:flutter/material.dart';
import 'package:flutter_application_1/Main_Menu/main_menu.dart';
import 'package:flutter_application_1/Widget_Setup/widgit_build.dart';
import 'package:flutter_application_1/auth_scope.dart';
import 'package:flutter_application_1/Storage/opponent.dart';

class GameOver extends StatefulWidget {
  const GameOver({super.key, required this.opponent, required this.victory,});
  final Opponent opponent;
  final bool victory;

  @override
  State<GameOver> createState() => _GameOverState();
}

// This class is the configuration for the state. It holds the values (in this
// case the title) provided by the parent (in this case the App widget) and
// used by the build method of the State. Fields in a Widget subclass are
// always marked "final".

class _GameOverState extends State<GameOver> {
  Future<void> _signOut() async {
    await AuthScope.of(context).logOut();
    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

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
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: widget.victory
                  ? Text(
                      "Congrats! You Win!\nYour Opponent: ${widget.opponent.username}, Loses!",
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    )
                  : Text(
                      "You Lose!\nYour Opponent: ${widget.opponent.username}, Wins!",
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
            ),
            Text(
              "Your word was: ${widget.opponent.word}!",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            NavStart().buildActionButton(
              context,
              "Back to Main Menu",
              () => Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(builder: (_) => MainMenu()),
              ),
            ),
            const SizedBox(height: 20),
            NavStart().buildActionButton(context, 'Sign Out', _signOut),
          ],
        ),
      ),
    );
  }
}
