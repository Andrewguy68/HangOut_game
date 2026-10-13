import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Game_Time/stick_man.dart';
import 'package:flutter_application_1/Storage/word_storage.dart';
import 'package:flutter_application_1/storage/opponent.dart';
import 'package:flutter_application_1/Game_Time/game_page.dart';


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

  final Opponent opponent;
  List<String> guessedLetter = [];

  WordStorage storage = WordStorage();
  
  String username = 'username';


//gets word
  void loadWord() {
   // List<String> words = storage.getWords();

   // if (words.isNotEmpty){
   //   var random = Random();
   //   String randomWord = words[random.nextInt(words.length)];
   //   return randomWord;
   // }
    //List<String, String> opponent = Opponent(username: username, word: word);
    String word = opponent.word;
  }
// checks word/victory
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
    word = loadWord(); 
    int lives = 0;
    int frame = 0;
    for (var i = 0; i < word.length; i++ ){
      if (guess == word){
        victory = true;
      }
      else if (guess[0] == word[i]){
        word[i] = guess[0];
      }
      else{
        guessedLetter.add(guess);
        lives++;
        frame++;
      }

    }
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