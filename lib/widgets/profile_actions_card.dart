
import 'package:flutter/material.dart';

class ProfileActionsCard extends StatelessWidget {
  const ProfileActionsCard({
    super.key,
    required this.onEdit,
  });

  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.edit_outlined),
        title: const Text('Edit Profile'),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onEdit,
      ),
    );
  }
}
