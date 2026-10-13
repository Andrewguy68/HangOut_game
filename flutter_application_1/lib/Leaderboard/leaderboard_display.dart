import 'package:flutter/material.dart';

import 'leaderboard.dart';

class LeaderboardDisplay extends StatelessWidget {
	const LeaderboardDisplay({super.key, required this.entries});

	final List<dynamic> entries;

	@override
	Widget build(BuildContext context) {
		final board = entries.take(5).toList();
		if (board.isEmpty) {
			return const Text('No one has made it on the Leaderboard.');
		}
		return Column(
			children: [
				for (var i = 0; i < board.length; i++)
					ListTile(
						leading: CircleAvatar(
							radius: 14,
							child: Text('${i + 1}'),
						),
						title: Text((board[i])),
					),
			],
		);
	}
}

