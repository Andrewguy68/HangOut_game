import 'package:flutter/material.dart';

import 'package:flutter_application_1/Game_Time/game_page.dart';
import 'package:flutter_application_1/Widget_Setup/widgit_build.dart';
import 'package:flutter_application_1/auth_scope.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

// This class is the configuration for the state. It holds the values (in this
// case the title) provided by the parent (in this case the App widget) and
// used by the build method of the State. Fields in a Widget subclass are
// always marked "final".

class _MainMenuState extends State<MainMenu> {
  Future<void> _signOut() async {
    await AuthScope.of(context).logOut();
    // AuthGate shows Login once the signed-out state arrives. If this menu was
    // pushed on top of other pages, drop them so Login is what's visible.
    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    //builds the main menu widget
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hang-Out!'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NavStart().buildNavButton(context, 'Start Game', const GameTime()),
            NavStart().buildActionButton(context, 'Sign Out', _signOut),
          ],
        ),
      ),
    );
  }
}
