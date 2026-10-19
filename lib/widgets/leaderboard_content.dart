import 'package:flutter/material.dart';

import '../models/leaderboard_page.dart';
import 'leaderboard_rankings.dart';
import 'leaderboard_state_view.dart';
import 'your_rank_card.dart';

/// What the leaderboard shows: the rankings, a spinner, or an error.
class LeaderboardContent extends StatelessWidget {
  const LeaderboardContent({
    super.key,
    required this.page,
    required this.loading,
    required this.error,
    required this.signedIn,
    required this.onSignIn,
    required this.onRetry,
  });

  final LeaderboardPage? page;
  final bool loading;
  final String? error;
  final bool signedIn;
  final VoidCallback onSignIn;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final current = page;

    if (current != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LeaderboardRankings(entries: current.entries),
          const SizedBox(height: 12),
          YourRankCard(signedIn: signedIn, me: current.me, onSignIn: onSignIn),
        ],
      );
    }

    if (loading) {
      return const SizedBox(
        height: 280,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      height: 280,
      child: LeaderboardStateView(
        title: 'Could not load rankings',
        message: error ?? 'Please try again.',
        icon: Icons.cloud_off_outlined,
        actionLabel: 'Try again',
        onAction: onRetry,
      ),
    );
  }
}
