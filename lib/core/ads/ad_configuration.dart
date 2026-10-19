import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../audience/audience_band.dart';

/// Ad request settings per age band. Children never reach the ads code, so
/// their entry is only a safe fallback.
///
/// Teenagers use Google's own `teen` treatment with G-rated content; only
/// adults get ordinary requests.
class AdConfiguration {
  const AdConfiguration._();

  // Developer phones only ever get test ads, so tapping an ad can never count
  // as invalid traffic once real ad unit IDs are in use.
  static const _developerTestDeviceIds = ['B94BD73EE10AF905924B68C356B70A99'];

  static RequestConfiguration forBand(AudienceBand band) {
    switch (band) {
      case AudienceBand.adult:
        return _build(
          AgeRestrictedTreatment.unspecified,
          MaxAdContentRating.pg,
        );
      case AudienceBand.teen:
        return _build(AgeRestrictedTreatment.teen, MaxAdContentRating.g);
      case AudienceBand.child:
        return _build(AgeRestrictedTreatment.child, MaxAdContentRating.g);
    }
  }

  static RequestConfiguration _build(
    AgeRestrictedTreatment treatment,
    String rating,
  ) {
    return RequestConfiguration(
      ageRestrictedTreatment: treatment,
      maxAdContentRating: rating,
      testDeviceIds: _developerTestDeviceIds,
    );
  }
}
