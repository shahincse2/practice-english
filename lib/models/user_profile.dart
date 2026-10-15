class UserProfile {
  const UserProfile({
    this.name = 'English Learner',
    this.email = '',
    this.level = 'Not selected',
    this.preferredType = 'All',
    this.joinedAt,
  });

  final String name;
  final String email;
  final String level;
  final String preferredType;
  final DateTime? joinedAt;

  UserProfile copyWith({
    String? name,
    String? email,
    String? level,
    String? preferredType,
    DateTime? joinedAt,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      level: level ?? this.level,
      preferredType: preferredType ?? this.preferredType,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'level': level,
      'preferredType': preferredType,
      'joinedAt': joinedAt?.toIso8601String(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String? ?? 'English Learner',
      email: json['email'] as String? ?? '',
      level: json['level'] as String? ?? 'Not selected',
      preferredType: json['preferredType'] as String? ?? 'All',
      joinedAt: _parseDate(json['joinedAt']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is! String) return null;
    return DateTime.tryParse(value);
  }
}
