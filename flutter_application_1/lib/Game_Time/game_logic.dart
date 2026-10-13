import 'package:flutter/material.dart';
import 'package:flutter_application_1/Game_Time/stick_man.dart';
import 'package:flutter_application_1/Storage/word_storage.dart';


class GameLogic extends StatefulWidget {
  const GameLogic({super.key});

  @override
  State<GameLogic> createState() => _GameLogicState();
}

class _GameLogicState extends State<GameLogic> {
  int frame = 0; // Current frame of the stick figure
  bool draw = true; // Whether to draw the line or not
  bool victory = false;
  String word = "word";
  String guess = "";
  bool gameOver = false;
  int failedAttempts = 0;

  List<String> guessedLetter = [];

  WordStorage storage = WordStorage();
  
  String username = 'username';

  Future<void> loadWord() {
    List<String> words = await storage.getWords();

    if (word.isNotEmpty){
      //logic
    }
  }

  void checkGuess(){
    guess = guess.toLowerCase().trim();

    if (guess.length != 1 || gameOver || word.isEmpty) {
      return;
    }
    if (guessedLetter.contains(guess)){
      return;
    }
    setState(() {
      guessedLetter.add(guess);
      if (!word.contains(guess)){
        if (failedAttempts <6){
          failedAttempts++;
        }
      }
    });
    if(gameOver){
      storage.saveWordResults(username, word, failedAttempts);
    }
  }

  void nextFrame() {
    setState(() {
      if (frame < 6) {
        frame++;
      } else {
        victory = true;
      }
    });
  }
  void game() {


  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomPaint(
          size: const Size(300, 300),
          painter: drawMan(frame, draw, victory),
        ),
        ElevatedButton(
          onPressed: nextFrame,
          child: const Text('Next Frame'), //this is for testing. Once we have words we can replace this.
        ),
      ],
    );
  }
}