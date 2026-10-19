import 'package:flutter/material.dart';

import '../core/api/account_profile_service.dart';
import '../core/api/api_exception.dart';
import '../core/auth/auth_service.dart';
import '../models/app_user.dart';
import 'nickname_tile.dart';

/// Account card for the profile: sign in, or sign out / delete account.
class AccountSection extends StatelessWidget {
  const AccountSection({
    super.key,
    required this.authService,
    required this.onSignIn,
    this.profileService,
    this.onSetupNickname,
  });

  /// Null when the sign-in backend is not available on this device.
  final AuthService? authService;
  final VoidCallback onSignIn;

  /// Null when there is no server profile to clean up.
  final AccountProfileService? profileService;

  /// Opens the nickname step (only used together with [profileService]).
  final Future<void> Function()? onSetupNickname;

  @override
  Widget build(BuildContext context) {
    final auth = authService;
    if (auth == null) {
      return const Card(
        child: ListTile(
          leading: Icon(Icons.cloud_off_outlined),
          title: Text('Sign-in is not available on this device'),
        ),
      );
    }

    return StreamBuilder<AppUser?>(
      stream: auth.userChanges,
      initialData: auth.currentUser,
      builder: (context, snapshot) {
        final user = snapshot.data;

        return Card(
          child: user == null
              ? ListTile(
                  leading: const Icon(Icons.login_rounded),
                  title: const Text('Sign in or create an account'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: onSignIn,
                )
              : _signedIn(context, auth, user),
        );
      },
    );
  }

  Widget _signedIn(BuildContext context, AuthService auth, AppUser user) {
    final danger = Theme.of(context).colorScheme.error;
    final profiles = profileService;
    final setup = onSetupNickname;

    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.account_circle_outlined),
          title: Text(user.email ?? 'Signed in'),
        ),
        if (profiles != null && setup != null)
          NicknameTile(key: ValueKey(user.uid), service: profiles, onSetup: setup),
        ListTile(
          leading: const Icon(Icons.logout_rounded),
          title: const Text('Sign out'),
          onTap: auth.signOut,
        ),
        ListTile(
          leading: Icon(Icons.delete_outline, color: danger),
          title: Text('Delete account', style: TextStyle(color: danger)),
          onTap: () => _confirmDelete(context, auth),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context, AuthService auth) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete account?'),
        content: const Text(
          'Your account will be permanently deleted. Practice history stored '
          'on this device is not affected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    String? problem;
    try {
      // Server data first; the sign-in account goes only if that worked.
      await profileService?.deleteProfile();
      await auth.deleteAccount();
    } on AuthFailure catch (failure) {
      problem = failure.message;
    } on ApiException catch (failure) {
      problem = failure.message;
    }

    if (problem != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(problem)),
      );
    }
  }
}
