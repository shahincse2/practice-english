
import 'package:flutter/material.dart';

import '../models/user_profile.dart';

class ProfileInformationCard extends StatelessWidget {
  const ProfileInformationCard({
    super.key,
    required this.profile,
  });

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _tile(
            Icons.school_outlined,
            'Learning Level',
            profile.level,
          ),
          _tile(
            Icons.category_outlined,
            'Practice Type',
            profile.preferredType,
          ),
          _tile(
            Icons.calendar_today_outlined,
            'Joined',
            _joinedDate(),
          ),
        ],
      ),
    );
  }

  Widget _tile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Text(value),
    );
  }

  String _joinedDate() {
    final date = profile.joinedAt;
    if (date == null) return 'Not available';

    return '${date.day}/${date.month}/${date.year}';
  }
}
