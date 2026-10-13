import 'package:flutter/material.dart';
import 'package:flutter_application_1/Leaderboard/leaderboard.dart';

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
						title: Text(display(board[i])),
					),
			],
		);
	}
	String display(dynamic entry) {
		if (entry is Map) {
			final name = entry['rank'] ?? entry['username'] ?? entry['failedAttempts'];
			if (name != null) return '$name';
		}

		try {
			final name = entry.name;
			if (name != null) return '$name';
			if (name != null) return name.toString();
		} catch (_) {

		}
		return entry?.toString() ?? '';
	}
}

