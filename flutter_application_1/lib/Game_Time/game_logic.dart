import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Leaderboard/leaderboard.dart';
import 'package:flutter_application_1/Game_Time/stick_man.dart';
import 'package:flutter_application_1/Storage/word_storage.dart';
import 'package:flutter_application_1/Storage/opponent.dart';
import 'package:flutter_application_1/Game_Time/game_page.dart';
import 'package:flutter_application_1/Game_Time/game_over.dart';


class GameLogic extends StatefulWidget {
  const GameLogic({super.key, required this.word, required this.opponent});
  final String word;
  final Opponent opponent;
  
  @override
  State<GameLogic> createState() => GameLogicState();
}

class GameLogicState extends State<GameLogic> {
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


  void nextFrame() {
    setState(() {
      if (frame < 6) {
        frame++;
      }
      if (frame >= 6){
        Timer(Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(
            builder:(context) => GameOver(opponent: widget.opponent, victory: victory),
          ),
        );
        });
      }
    });
  }
  void game() {
    String word = widget.word.toLowerCase().trim();
    List<String>letters = word.split("");  
    int lives = 0;
    int frame = 0;
    
    if (gameOver || guess.isEmpty){
      return;
    }
    
    guess = guess.toLowerCase().trim();

    setState(() {
      if (guess == word){
          victory = true;
          gameOver = true;
          return;
        }
        if (guessedLetter.contains(guess)){
          return;
        }
        bool correct = false;

        for (var i = 0; i < letters.length; i++ ){
          if (guess[0] == letters[i]){
            correct = true;
          }
        }
        guessedLetter.add(guess);
        
        if(!correct){
          lives++;
          nextFrame();
          failedAttempts++;
        }
        bool allGuessed = true;
        
        for (var i = 0; i < letters.length; i++) {
          if (!guessedLetter.contains(letters[i])) {
            allGuessed = false;
          }
        }
        if (allGuessed){
          victory = true;
          gameOver = true;
        }
        if (failedAttempts >= 6){
          gameOver = true;
        }
      });
  
  }
  
  String displayWord(){
    String display = "";
    
    for (var i = 0; i < widget.word.length; i++) {
      if (guessedLetter.contains(widget.word[i].toLowerCase())) {
        display += "${widget.word[i]} ";
      } else {
        display += "_ ";
      }
    }

    return display;
  }

  
 


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomPaint(
          size: const Size(300, 300),
          painter: drawMan(frame),
        ),
        Text(
        displayWord(),
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      ],
    );
  }
}