
import 'package:flutter/material.dart';

import '../models/user_profile.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        CircleAvatar(
          radius: 44,
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            Icons.person_rounded,
            size: 48,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          profile.name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (profile.email.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            profile.email,
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
