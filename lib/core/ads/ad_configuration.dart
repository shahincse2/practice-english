import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../audience/audience_band.dart';

/// Ad request settings per age band. Children never reach the ads code.
///
/// Teenagers get child-safe requests (no personalised ads, G-rated content);
/// only adults get ordinary requests.
class AdConfiguration {
  const AdConfiguration._();

  // Developer phones only ever get test ads, so tapping an ad can never count
  // as invalid traffic once real ad unit IDs are in use.
  static const _developerTestDeviceIds = ['B94BD73EE10AF905924B68C356B70A99'];

  static RequestConfiguration forBand(AudienceBand band) {
    return band == AudienceBand.adult ? _adult() : childSafe();
  }

  static RequestConfiguration _adult() {
    return RequestConfiguration(
      tagForChildDirectedTreatment: TagForChildDirectedTreatment.no,
      tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.no,
      maxAdContentRating: MaxAdContentRating.pg,
      testDeviceIds: _developerTestDeviceIds,
    );
  }

  static RequestConfiguration childSafe() {
    return RequestConfiguration(
      tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
      tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.yes,
      maxAdContentRating: MaxAdContentRating.g,
      testDeviceIds: _developerTestDeviceIds,
    );
  }
}
