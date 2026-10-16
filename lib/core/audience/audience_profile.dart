import '../../data/practice_catalog.dart';
import '../../models/practice_level.dart';
import '../../models/practice_segment.dart';
import 'audience_band.dart';

/// What the app may do for one age band.
///
/// Screens and services ask this class instead of checking ages themselves,
/// so every rule about children lives in one place.
class AudienceProfile {
  const AudienceProfile(this.band);

  /// The most restrictive profile, used while the age is not known yet.
  static const child = AudienceProfile(AudienceBand.child);

  /// Children only see content written for their age.
  static const _childLevels = {
    PracticeLevel.nursery,
    PracticeLevel.kg,
    PracticeLevel.class1,
    PracticeLevel.class2,
    PracticeLevel.class3,
    PracticeLevel.class4,
    PracticeLevel.class5,
    PracticeLevel.class6,
    PracticeLevel.class7,
  };

  final AudienceBand band;

  bool get isChild => band == AudienceBand.child;

  /// Firebase, analytics and ads are never started for children.
  bool get allowsThirdPartyServices => !isChild;
  bool get allowsSignIn => !isChild;
  bool get allowsLeaderboard => !isChild;
  bool get allowsAds => !isChild;

  List<PracticeSegment> get segments {
    if (!isChild) return PracticeSegment.values;

    return const [PracticeSegment.kids, PracticeSegment.school];
  }

  List<PracticeLevel> levelsFor(PracticeSegment segment) {
    final levels = PracticeCatalog.levels[segment] ?? const <PracticeLevel>[];
    if (!isChild) return levels;

    return levels.where(_childLevels.contains).toList();
  }
}
