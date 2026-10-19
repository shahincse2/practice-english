import '../../models/account_profile.dart';
import 'account_profile_service.dart';
import 'api_client.dart';
import 'api_exception.dart';

class ApiAccountProfileService implements AccountProfileService {
  const ApiAccountProfileService(this._client);

  final ApiClient _client;

  @override
  Future<AccountProfile?> getProfile() async {
    try {
      final json = await _client.get('/v1/me');
      return AccountProfile.fromJson(json as Map<String, dynamic>);
    } on ApiException catch (error) {
      if (error.isNotFound) return null;
      rethrow;
    }
  }

  @override
  Future<AccountProfile> saveProfile({
    required String displayName,
    required bool leaderboardVisible,
    required bool confirmedAge13Plus,
    int? upazilaId,
  }) async {
    final json = await _client.put('/v1/me', {
      'displayName': displayName.trim(),
      'confirmedAge13Plus': confirmedAge13Plus,
      'leaderboardVisible': leaderboardVisible,
      'upazilaId': ?upazilaId,
    });
    return AccountProfile.fromJson(json as Map<String, dynamic>);
  }

  @override
  Future<void> deleteProfile() async {
    try {
      await _client.delete('/v1/me');
    } on ApiException catch (error) {
      if (!error.isNotFound) rethrow;
    }
  }
}
