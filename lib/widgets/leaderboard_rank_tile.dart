import 'package:flutter/material.dart';

import '../models/leaderboard_entry.dart';

class LeaderboardRankTile extends StatelessWidget {
  const LeaderboardRankTile({required this.entry, super.key});

  final LeaderboardEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      elevation: 0,
      color: entry.isCurrentUser
          ? colors.primaryContainer.withValues(alpha: 0.65)
          : colors.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: Text(
                '${entry.rank}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            CircleAvatar(
              radius: 21,
              backgroundColor: colors.primaryContainer,
              child: Text(
                _initials(entry.displayName),
                style: TextStyle(
                  color: colors.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.isCurrentUser
                        ? '${entry.displayName} (You)'
                        : entry.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${entry.streakDays} day streak',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${entry.points}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text('points', style: theme.textTheme.labelSmall),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.isEmpty || words.first.isEmpty) return '?';
    if (words.length == 1) return words.first.characters.first.toUpperCase();
    return '${words.first.characters.first}${words.last.characters.first}'
        .toUpperCase();
  }
}
