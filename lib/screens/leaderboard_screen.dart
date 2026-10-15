import 'package:flutter/material.dart';

import '../data/leaderboard_preview_data.dart';
import '../models/leaderboard_entry.dart';
import '../models/leaderboard_period.dart';
import '../widgets/leaderboard_period_filter.dart';
import '../widgets/leaderboard_podium.dart';
import '../widgets/leaderboard_rank_tile.dart';
import '../widgets/leaderboard_state_view.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  LeaderboardPeriod _period = LeaderboardPeriod.weekly;

  @override
  Widget build(BuildContext context) {
    final entries =
        leaderboardPreviewEntries[_period] ?? const <LeaderboardEntry>[];
    final topThree = entries.where((entry) => entry.rank <= 3).toList();
    final remaining = entries.where((entry) => entry.rank > 3).toList();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Text(
              'Learn, improve, and climb the ranks.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            const _PreviewNotice(),
            const SizedBox(height: 16),
            LeaderboardPeriodFilter(
              selected: _period,
              onChanged: (value) => setState(() => _period = value),
            ),
            const SizedBox(height: 18),
            if (entries.isEmpty)
              const SizedBox(
                height: 280,
                child: LeaderboardStateView(
                  title: 'No rankings yet',
                  message:
                  'Global rankings will appear here when data is available.',
                  icon: Icons.emoji_events_outlined,
                ),
              )
            else ...[
              LeaderboardPodium(entries: topThree),
              const SizedBox(height: 20),
              Text('Global Rankings', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              for (final entry in remaining) ...[
                LeaderboardRankTile(entry: entry),
                const SizedBox(height: 2),
              ],
              const SizedBox(height: 12),
              _YourRankCard(onSignIn: _showSignInNotice),
            ],
          ],
        ),
      ),
    );
  }

  void _showSignInNotice() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sign-in will be available with the online leaderboard.'),
      ),
    );
  }
}

class _PreviewNotice extends StatelessWidget {
  const _PreviewNotice();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.tertiaryContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: colors.onTertiaryContainer),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Preview rankings — sample data only. Live global rankings are not connected yet.',
              style: TextStyle(color: colors.onTertiaryContainer),
            ),
          ),
        ],
      ),
    );
  }
}

class _YourRankCard extends StatelessWidget {
  const _YourRankCard({required this.onSignIn});

  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: colors.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.person_outline, color: colors.onPrimaryContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Sign in to see your rank',
                style: TextStyle(
                  color: colors.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(onPressed: onSignIn, child: const Text('Sign in')),
          ],
        ),
      ),
    );
  }
}