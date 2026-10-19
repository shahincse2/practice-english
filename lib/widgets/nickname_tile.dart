import 'package:flutter/material.dart';

import '../core/api/account_profile_service.dart';
import '../models/account_profile.dart';

/// Shows the signed-in user's nickname, or lets them choose one.
class NicknameTile extends StatefulWidget {
  const NicknameTile({super.key, required this.service, required this.onSetup});

  final AccountProfileService service;

  /// Opens the nickname step. The tile reloads when it returns.
  final Future<void> Function() onSetup;

  @override
  State<NicknameTile> createState() => _NicknameTileState();
}

class _NicknameTileState extends State<NicknameTile> {
  late Future<AccountProfile?> _profile = widget.service.getProfile();

  Future<void> _setup() async {
    await widget.onSetup();
    if (mounted) setState(() => _profile = widget.service.getProfile());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AccountProfile?>(
      future: _profile,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const ListTile(
            leading: Icon(Icons.badge_outlined),
            title: Text('Nickname'),
            subtitle: Text('Loading...'),
          );
        }

        final name = snapshot.data?.displayName;
        if (name != null) {
          return ListTile(
            leading: const Icon(Icons.badge_outlined),
            title: Text(name),
            subtitle: const Text('Your nickname on the leaderboard'),
          );
        }

        final failed = snapshot.hasError;
        return ListTile(
          leading: const Icon(Icons.badge_outlined),
          title: Text(failed ? 'Could not load nickname' : 'Choose a nickname'),
          subtitle: Text(
            failed ? 'Tap to try again' : 'Needed to appear on the leaderboard',
          ),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: _setup,
        );
      },
    );
  }
}
