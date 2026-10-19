import 'account_profile_service.dart';
import 'api_account_profile_service.dart';
import 'default_api_client.dart';

/// The account API for the app, or null when it is not available.
AccountProfileService? defaultAccountProfileService() {
  final client = defaultApiClient();

  return client == null ? null : ApiAccountProfileService(client);
}
