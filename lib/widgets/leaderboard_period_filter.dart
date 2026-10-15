import 'package:flutter/material.dart';

import '../models/leaderboard_period.dart';

class LeaderboardPeriodFilter extends StatelessWidget {
  const LeaderboardPeriodFilter({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final LeaderboardPeriod selected;
  final ValueChanged<LeaderboardPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<LeaderboardPeriod>(
      segments: const [
        ButtonSegment(value: LeaderboardPeriod.weekly, label: Text('Weekly')),
        ButtonSegment(value: LeaderboardPeriod.monthly, label: Text('Monthly')),
        ButtonSegment(value: LeaderboardPeriod.allTime, label: Text('All-time')),
      ],
      selected: {selected},
      onSelectionChanged: (value) => onChanged(value.first),
      showSelectedIcon: false,
    );
  }
}
