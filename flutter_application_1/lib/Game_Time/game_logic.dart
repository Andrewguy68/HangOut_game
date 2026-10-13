import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Game_Time/stick_man.dart';
import 'package:flutter_application_1/Game_Time/game_over.dart';



class GameLogic extends StatefulWidget {
  const GameLogic({super.key});

  @override
  State<GameLogic> createState() => _GameLogicState();
}

class _GameLogicState extends State<GameLogic> {
  int frame = 0; // Current frame of the stick figure

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
            builder:(context) => const GameOver(),
          ),
        );
        });
      }
    });
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
        ElevatedButton(
          onPressed: nextFrame,
          child: const Text('Next Frame'), //this is for testing. Once we have words we can replace this.
        ),
      ],
    );
  }
}