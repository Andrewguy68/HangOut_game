import 'package:flutter/material.dart';
import 'package:flutter_application_1/Game_Time/game_logic.dart';
import 'package:flutter_application_1/Storage/opponent.dart';
import 'package:flutter_application_1/Widget_Setup/widgit_build.dart';
import 'package:flutter_application_1/Main_Menu/main_menu.dart';

class GameTime extends StatefulWidget {
  const GameTime({super.key, required this.opponent});

  final Opponent opponent;

  @override
  State<GameTime> createState() => _GameTimeState();
}

// This class is the configuration for the state. It holds the values (in this
// case the title) provided by the parent (in this case the App widget) and
// used by the build method of the State. Fields in a Widget subclass are
// always marked "final".

class _GameTimeState extends State<GameTime> {
  @override
  final TextEditingController guessController = TextEditingController();
  final GlobalKey<GameLogicState> gameKey = GlobalKey<GameLogicState>();
  String guessedLetters = "";
  Text guessedDisplay = Text("");

  final Set<String> usedLetters = {};

//adds a usedLetters set and a guessletter() method. submitguess now calls it, so the text field
//and the keyboard handle guesses the same way. removs the unused update method
  void guessLetter(String letter) {
    letter = letter.toLowerCase();

    if (usedLetters.contains(letter)) return;

    setState(() {
      usedLetters.add(letter);
      guessedLetters += "$letter, ";
      guessedDisplay = Text("Already tried:  $guessedLetters");
    });

    gameKey.currentState?.guess = letter;
    gameKey.currentState?.game();
  }
  
  void submitGuess(){
    String guess = guessController.text;
    
    if (guess.length > 1 || guess.contains(RegExp(r'[^a-zA-Z]'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a single letter."),
        ),
      );
      guessController.clear();
    }
    else {
      guessLetter(guess);
      guessController.clear();
    }
  }

  void submitSolve(){
    String guess = guessController.text;

    gameKey.currentState?.guess = guess;
    gameKey.currentState?.solve();

    guessController.clear();
  }

  @override
  void dispose() {
    guessController.dispose();
    super.dispose();
  }
//added buildkeyboard(), which makes a key for each letter, letters that have already been guessed
// are disabled and blacked out so they can't be tapped again
  Widget buildKeyboard() {
    const rows = ['qwertyuiop', 'asdfghjkl', 'zxcvbnm'];

    return Column(
      children: rows.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.split('').map((letter) {
            final used = usedLetters.contains(letter);
            return Padding(
              padding: const EdgeInsets.all(2),
              child: SizedBox(
                width: 30,
                height: 44,
                child: ElevatedButton(
                  key: Key('key-$letter'),
                  onPressed: used ? null : () => guessLetter(letter),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    disabledBackgroundColor: Colors.black,
                    disabledForegroundColor: Colors.grey,
                  ),
                  child: Text(letter.toUpperCase()),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
//placed the keyboard below the solve button and wraps the page in a singlechildscrollview so the 
//taller layout doesn't overflow on small screens
  @override
  Widget build(BuildContext context) {
    //builds the main menu widget
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hang-Out Time!',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You are playing against ${widget.opponent.username}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GameLogic(
              key: gameKey,
              word: widget.opponent.word,
              opponent: widget.opponent,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: guessedDisplay,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextField(
                controller: guessController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter a Letter',
                  labelStyle: TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitGuess,
              child: const Text('Add a Letter'),
            ), //this will check the letter and call the letter input function
            ElevatedButton(
              onPressed: submitSolve, 
              child: const Text("Solve")), //this will check the word and call the solve function

            const SizedBox(height: 10),
            buildKeyboard(),
          ],
        ),
        ),
      ),
    );
  }
}