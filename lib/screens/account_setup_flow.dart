import 'package:flutter/material.dart';

import '../core/api/account_profile_service.dart';
import '../core/api/api_exception.dart';
import '../core/auth/auth_service.dart';
import 'login_screen.dart';
import 'nickname_setup_screen.dart';

/// Opens the sign-in screen and, after a successful sign-in, the nickname
/// step. Returns true when the user signed in.
Future<bool> signInAndSetup(
  BuildContext context, {
  required AuthService? auth,
  required AccountProfileService? profiles,
}) async {
  if (auth == null) return false;

  final signedIn = await Navigator.of(context).push<bool>(
    MaterialPageRoute(builder: (_) => LoginScreen(authService: auth)),
  );
  if (signedIn != true || !context.mounted) return false;

  await ensureAccountProfile(context, profiles);
  return true;
}

/// If the user has no server profile yet, asks for a nickname. Does nothing
/// when the API is not available.
Future<void> ensureAccountProfile(
  BuildContext context,
  AccountProfileService? service,
) async {
  if (service == null) return;

  try {
    if (await service.getProfile() != null) return;
  } on ApiException catch (error) {
    debugPrint('Could not load the profile: $error');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    }
    return;
  }
  if (!context.mounted) return;

  await Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => NicknameSetupScreen(service: service)),
  );
}
