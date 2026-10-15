import 'package:flutter/material.dart';

import '../models/leaderboard_entry.dart';

class LeaderboardPodium extends StatelessWidget {
  const LeaderboardPodium({required this.entries, super.key});

  final List<LeaderboardEntry> entries;

  @override
  Widget build(BuildContext context) {
    final byRank = {for (final entry in entries) entry.rank: entry};
    final ordered = [byRank[2], byRank[1], byRank[3]];

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer.withValues(
        alpha: 0.45,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 14),
        child: Column(
          children: [
            Text(
              'TOP LEARNERS',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final entry in ordered)
                  Expanded(
                    child: entry == null
                        ? const SizedBox.shrink()
                        : _PodiumItem(entry: entry),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PodiumItem extends StatelessWidget {
  const _PodiumItem({required this.entry});

  final LeaderboardEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final first = entry.rank == 1;
    final medalColor = switch (entry.rank) {
      1 => const Color(0xFFB88722),
      2 => const Color(0xFF7A8580),
      _ => const Color(0xFFAD7047),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Column(
        children: [
          Icon(first ? Icons.emoji_events_rounded : Icons.workspace_premium,
              color: medalColor, size: first ? 30 : 25),
          const SizedBox(height: 5),
          CircleAvatar(
            radius: first ? 27 : 23,
            backgroundColor: medalColor.withValues(alpha: 0.18),
            child: Text(
              _initial(entry.displayName),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            entry.displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text('#${entry.rank}', style: theme.textTheme.bodySmall),
          Text(
            '${entry.points} pts',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  String _initial(String name) {
    final value = name.trim();
    return value.isEmpty ? '?' : value.characters.first.toUpperCase();
  }
}
