/// The age group a user belongs to. Only this band is stored on the device,
/// never the date of birth.
enum AudienceBand {
  child,
  teen,
  adult;

  /// Works out the band from a month and year of birth.
  ///
  /// The day is unknown, so the birthday is assumed to be at the end of the
  /// month: when in doubt the younger band is chosen. Impossible (future)
  /// dates also end up as [child].
  static AudienceBand fromBirth({
    required int year,
    required int month,
    required DateTime now,
  }) {
    var age = now.year - year;
    if (now.month <= month) age -= 1;

    if (age < 13) return AudienceBand.child;
    if (age < 18) return AudienceBand.teen;
    return AudienceBand.adult;
  }
}
