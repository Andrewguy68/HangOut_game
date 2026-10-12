import 'package:flutter/material.dart';
import 'package:pop_overlay/pop_overlay.dart';

class popUp extends StatelessWidget {
  const popUp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Title(
                title: 'Add a word!',
                color: Colors.black,
                child: Text('add a word!!'),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                                  PopOverlay.addPop(
                    PopOverlayContent(
                      id: 'overlay',
                      widget: Container(
                        padding: const EdgeInsets.all(16),
                        child: const Text('Add a word'),
                        //child: const TextField(
                          //decoration: InputDecoration(
                            //hintText: 'Enter a word',
                          //),
                        //),
                      ),
                    ),
                  );
                },
                child: const Text('Show Pop Overlay'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}