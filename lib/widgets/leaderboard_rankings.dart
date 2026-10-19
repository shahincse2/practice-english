import 'package:flutter/material.dart';

import '../models/leaderboard_entry.dart';
import 'leaderboard_podium.dart';
import 'leaderboard_rank_tile.dart';
import 'leaderboard_state_view.dart';

/// The podium for the top three and a tile for everyone else.
class LeaderboardRankings extends StatelessWidget {
  const LeaderboardRankings({super.key, required this.entries});

  final List<LeaderboardEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const SizedBox(
        height: 280,
        child: LeaderboardStateView(
          title: 'No rankings yet',
          message: 'Finish a practice session to appear here.',
          icon: Icons.emoji_events_outlined,
        ),
      );
    }

    final topThree = entries.where((entry) => entry.rank <= 3).toList();
    final remaining = entries.where((entry) => entry.rank > 3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LeaderboardPodium(entries: topThree),
        const SizedBox(height: 20),
        Text('Global Rankings', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        for (final entry in remaining) ...[
          LeaderboardRankTile(entry: entry),
          const SizedBox(height: 2),
        ],
      ],
    );
  }
}
