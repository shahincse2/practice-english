import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_profile.dart';

class UserProfileService {
  UserProfileService._();

  static final instance = UserProfileService._();

  static const _key = 'user_profile';

  Future<UserProfile> load() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);

    if (value == null) {
      return UserProfile(joinedAt: DateTime.now());
    }

    try {
      final decoded = jsonDecode(value);

      if (decoded is Map) {
        return UserProfile.fromJson(Map<String, dynamic>.from(decoded));
      }
    } catch (_) {}

    return UserProfile(joinedAt: DateTime.now());
  }

  Future<void> save(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_key, jsonEncode(profile.toJson()));
  }
}
