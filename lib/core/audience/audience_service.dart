import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'audience_band.dart';
import 'audience_profile.dart';

/// Remembers the age band chosen on the age screen.
class AudienceService {
  AudienceService._();

  static final instance = AudienceService._();

  static const _bandKey = 'audience_band';

  /// Null until the age screen has been answered.
  final profile = ValueNotifier<AudienceProfile?>(null);

  /// The current profile; the most restrictive one while it is unknown.
  AudienceProfile get current => profile.value ?? AudienceProfile.child;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_bandKey);

    final matches = AudienceBand.values.where((band) => band.name == saved);
    if (matches.isNotEmpty) profile.value = AudienceProfile(matches.first);
  }

  /// Saves the band once. Later calls do nothing, so the answer cannot be
  /// changed by going back and trying again.
  Future<void> answer(AudienceBand band) async {
    if (profile.value != null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_bandKey, band.name);
    profile.value = AudienceProfile(band);
  }
}
