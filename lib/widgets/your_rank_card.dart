import 'package:flutter/material.dart';

import '../models/leaderboard_entry.dart';

/// The signed-in user's own rank, or an invitation to sign in.
class YourRankCard extends StatelessWidget {
  const YourRankCard({
    super.key,
    required this.signedIn,
    required this.me,
    required this.onSignIn,
  });

  final bool signedIn;
  final LeaderboardEntry? me;
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
                _message(),
                style: TextStyle(
                  color: colors.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (!signedIn)
              TextButton(onPressed: onSignIn, child: const Text('Sign in')),
          ],
        ),
      ),
    );
  }

  String _message() {
    final rank = me;
    if (!signedIn) return 'Sign in to see your rank';
    if (rank == null) return 'Finish a practice session to get ranked';

    return '#${rank.rank}  ${rank.displayName}  -  ${rank.points} pts';
  }
}
