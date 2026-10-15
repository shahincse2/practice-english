import 'package:flutter/material.dart';

import '../models/user_profile.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
    required this.profile,
    required this.onSave,
  });

  final UserProfile profile;
  final Future<void> Function(UserProfile profile) onSave;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  String _level = '';
  String _type = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _emailController = TextEditingController(text: widget.profile.email);
    _level = widget.profile.level;
    _type = widget.profile.preferredType;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) return;

    final profile = widget.profile.copyWith(
      name: name,
      email: _emailController.text.trim(),
      level: _level,
      preferredType: _type,
    );

    await widget.onSave(profile);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _nameController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _level,
            decoration: const InputDecoration(
              labelText: 'Learning Level',
              border: OutlineInputBorder(),
            ),
            items: const [
              'Not selected',
              'Nursery',
              'KG',
              'Class 1',
              'Class 2',
              'Class 3',
              'Class 4',
              'Class 5',
              'Class 6',
              'Class 7',
              'Class 8',
              'Class 9',
              'Class 10',
              'HSC',
              'University',
              'IELTS',
              'GRE',
              'Spoken English',
            ].map(_item).toList(),
            onChanged: (value) {
              if (value != null) setState(() => _level = value);
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _type,
            decoration: const InputDecoration(
              labelText: 'Preferred Practice',
              border: OutlineInputBorder(),
            ),
            items: const [
              'All',
              'Word',
              'Phrase',
              'Sentence',
            ].map(_item).toList(),
            onChanged: (value) {
              if (value != null) setState(() => _type = value);
            },
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: _save,
              child: const Text('Save Changes'),
            ),
          ),
        ],
      ),
    );
  }

  DropdownMenuItem<String> _item(String value) {
    return DropdownMenuItem(value: value, child: Text(value));
  }
}
