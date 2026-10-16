import '../../models/practice_segment.dart';
import '../audience/audience_profile.dart';

/// Decides where ads may appear.
///
/// Free of any ads SDK, so the rules are easy to read, test and change in
/// one place.
class AdPolicy {
  const AdPolicy({this.adFreeSegments = const {PracticeSegment.kids}});

  /// Segments where ads must never be requested or shown (children's content).
  final Set<PracticeSegment> adFreeSegments;

  /// [segmentName] is a [PracticeSegment] name. Children never get ads, and
  /// an unknown or missing segment (for example a session that mixes all
  /// segments) gets none either, to be safe.
  bool allowsAdsFor(String? segmentName, {required AudienceProfile audience}) {
    if (!audience.allowsAds) return false;

    final matches = PracticeSegment.values.where(
      (segment) => segment.name == segmentName,
    );
    if (matches.isEmpty) return false;

    return !adFreeSegments.contains(matches.first);
  }
}
