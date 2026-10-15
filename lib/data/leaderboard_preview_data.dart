import '../models/leaderboard_entry.dart';
import '../models/leaderboard_period.dart';

/// Sample data for UI preview only. Replace with repository data before release.
const leaderboardPreviewEntries = <LeaderboardPeriod, List<LeaderboardEntry>>{
  LeaderboardPeriod.weekly: [
    LeaderboardEntry(
      rank: 1,
      displayName: 'Alex Morgan',
      points: 950,
      streakDays: 12,
    ),
    LeaderboardEntry(
      rank: 2,
      displayName: 'Taylor Reed',
      points: 820,
      streakDays: 9,
    ),
    LeaderboardEntry(
      rank: 3,
      displayName: 'Jordan Lee',
      points: 760,
      streakDays: 7,
    ),
    LeaderboardEntry(
      rank: 4,
      displayName: 'Casey Brown',
      points: 690,
      streakDays: 6,
    ),
    LeaderboardEntry(
      rank: 5,
      displayName: 'Sam Wilson',
      points: 640,
      streakDays: 5,
    ),
    LeaderboardEntry(
      rank: 6,
      displayName: 'Jamie Parker',
      points: 590,
      streakDays: 4,
    ),
  ],
  LeaderboardPeriod.monthly: [
    LeaderboardEntry(
      rank: 1,
      displayName: 'Taylor Reed',
      points: 3250,
      streakDays: 9,
    ),
    LeaderboardEntry(
      rank: 2,
      displayName: 'Alex Morgan',
      points: 3020,
      streakDays: 12,
    ),
    LeaderboardEntry(
      rank: 3,
      displayName: 'Sam Wilson',
      points: 2780,
      streakDays: 5,
    ),
    LeaderboardEntry(
      rank: 4,
      displayName: 'Jordan Lee',
      points: 2510,
      streakDays: 7,
    ),
    LeaderboardEntry(
      rank: 5,
      displayName: 'Casey Brown',
      points: 2340,
      streakDays: 6,
    ),
    LeaderboardEntry(
      rank: 6,
      displayName: 'Jamie Parker',
      points: 2090,
      streakDays: 4,
    ),
  ],
  LeaderboardPeriod.allTime: [
    LeaderboardEntry(
      rank: 1,
      displayName: 'Jordan Lee',
      points: 18400,
      streakDays: 7,
    ),
    LeaderboardEntry(
      rank: 2,
      displayName: 'Alex Morgan',
      points: 16950,
      streakDays: 12,
    ),
    LeaderboardEntry(
      rank: 3,
      displayName: 'Taylor Reed',
      points: 15760,
      streakDays: 9,
    ),
    LeaderboardEntry(
      rank: 4,
      displayName: 'Jamie Parker',
      points: 14200,
      streakDays: 4,
    ),
    LeaderboardEntry(
      rank: 5,
      displayName: 'Casey Brown',
      points: 13590,
      streakDays: 6,
    ),
    LeaderboardEntry(
      rank: 6,
      displayName: 'Sam Wilson',
      points: 12900,
      streakDays: 5,
    ),
  ],
};
