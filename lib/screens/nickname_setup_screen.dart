import 'package:flutter/material.dart';

import '../core/api/account_profile_service.dart';
import '../core/api/api_exception.dart';
import '../core/audience/audience_service.dart';

/// Asks for the public nickname shown on the leaderboard.
/// Pops with the saved profile, or null when the user skips it.
class NicknameSetupScreen extends StatefulWidget {
  const NicknameSetupScreen({super.key, required this.service});

  final AccountProfileService service;

  @override
  State<NicknameSetupScreen> createState() => _NicknameSetupScreenState();
}

class _NicknameSetupScreenState extends State<NicknameSetupScreen> {
  static final _pattern = RegExp(r'^[A-Za-z0-9_.-]{3,20}$');

  final _formKey = GlobalKey<FormState>();
  final _nickname = TextEditingController();

  bool _visible = true;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _nickname.dispose();
    super.dispose();
  }

  String? _validate(String? value) {
    if (_pattern.hasMatch(value?.trim() ?? '')) return null;

    return 'Use 3-20 letters, numbers, _ . or -';
  }

  Future<void> _save() async {
    if (_busy || !_formKey.currentState!.validate()) return;

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final profile = await widget.service.saveProfile(
        displayName: _nickname.text,
        leaderboardVisible: _visible,
        confirmedAge13Plus: AudienceService.instance.current.allowsSignIn,
      );
      if (mounted) Navigator.of(context).pop(profile);
    } on ApiException catch (failure) {
      if (mounted) setState(() => _error = failure.message);
    } catch (error) {
      debugPrint('Saving the profile failed: $error');
      if (mounted) setState(() => _error = 'Something went wrong. Try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Choose a nickname')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'This is the name other learners see on the '
                      'leaderboard. Please do not use your real name or '
                      'contact details.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _nickname,
                      enabled: !_busy,
                      autocorrect: false,
                      enableSuggestions: false,
                      maxLength: 20,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _save(),
                      decoration: const InputDecoration(
                        labelText: 'Nickname',
                        prefixIcon: Icon(Icons.badge_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: _validate,
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Show me on the leaderboard'),
                      value: _visible,
                      onChanged: _busy
                          ? null
                          : (value) => setState(() => _visible = value),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ],
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: _busy ? null : _save,
                      child: _busy
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Save'),
                    ),
                    TextButton(
                      onPressed: _busy
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('Not now'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
