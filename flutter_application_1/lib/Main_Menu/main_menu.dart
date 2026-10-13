import 'package:flutter/material.dart';
import 'package:flutter_application_1/Game_Time/game_page.dart';
import 'package:flutter_application_1/Main_Menu/add_word_dialog.dart';
import 'package:flutter_application_1/Storage/word_scope.dart';
import 'package:flutter_application_1/Storage/word_service.dart';
import 'package:flutter_application_1/Widget_Setup/widgit_build.dart';
import 'package:flutter_application_1/auth_scope.dart';
import 'package:flutter_application_1/Leaderboard/leaderboard.dart';


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
  final Leaderboard leaderboard = Leaderboard();
  late final Future<List<({int rank, String username, int failedAttempts})>>
  _leaders = leaderboard.getLeaderboard();
  bool _starting = false;

  Future<void> _signOut() async {
    await AuthScope.of(context).logOut();
    // AuthGate shows Login once the signed-out state arrives. If this menu was
    // pushed on top of other pages, drop them so Login is what's visible.
    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<void> _addWord() async {
    final word = await showAddWordDialog(context);
    if (!mounted || word == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"$word" saved! Other players can now play against it.'),
      ),
    );
  }

  Future<void> _startGame() async {
    final words = WordScope.of(context);
    setState(() => _starting = true);
    try {
      final opponent = await words.pickOpponent();
      if (!mounted) return;
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => GameTime(opponent: opponent)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(wordErrorMessage(e))));
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    //builds the main menu widget
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hang-Out!',
          style: Theme.of(context).textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Leaderboard",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              FutureBuilder<
                List<({int rank, String username, int failedAttempts})>
              >(
                future: _leaders,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData ||
                      snapshot.data == null ||
                      snapshot.data!.isEmpty) {
                    return const Text("No one has made it on the Leaderboard");
                  }
                  final leaders = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: leaders.length,
                    itemBuilder: (context, index) {
                      final player = leaders[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(child: Text('${player.rank}')),
                          title: Text(player.username),
                          subtitle: Text(
                            "Failed Attempts: ${player.failedAttempts}",
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              //LeaderboardDisplay(entries: entries),
              NavStart().buildActionButton(
                context,
                'Start Game',
                _startGame,
                loading: _starting,
              ),
              NavStart().buildActionButton(context, 'Add Word', _addWord),
              NavStart().buildActionButton(context, 'Sign Out', _signOut),
            ],
          ),
        ),
      ),
    );
  }
}
