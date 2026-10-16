import 'package:flutter/material.dart';

import '../core/audience/audience_service.dart';
import '../core/auth/default_auth_service.dart';
import '../core/services/practice_session_service.dart';
import '../core/services/practice_stats_service.dart';
import '../core/services/user_profile_service.dart';
import '../models/user_profile.dart';
import '../widgets/account_section.dart';
import '../widgets/profile_actions_card.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_information_card.dart';
import '../widgets/profile_learning_overview.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _service = UserProfileService.instance;
  final _stats = PracticeStatsService.instance;
  final _sessions = PracticeSessionService.instance;
  final _auth = defaultAuthService();
  final _audience = AudienceService.instance.current;

  UserProfile _profile = const UserProfile();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await _service.load();
    await _stats.initialize();
    await _sessions.initialize();

    if (!mounted) return;

    setState(() {
      _profile = profile;
      _loading = false;
    });
  }

  Future<void> _editProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            EditProfileScreen(profile: _profile, onSave: _saveProfile),
      ),
    );
  }

  Future<void> _openLogin() async {
    final auth = _auth;
    if (auth == null) return;

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen(authService: auth)),
    );
  }

  Future<void> _saveProfile(UserProfile profile) async {
    await _service.save(profile);
    if (!mounted) return;
    setState(() => _profile = profile);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        children: [
          ProfileHeader(profile: _profile),
          const SizedBox(height: 24),
          _title('Learning Overview'),
          const SizedBox(height: 8),
          ValueListenableBuilder<int>(
            valueListenable: _sessions.completedSessions,
            builder: (_, completedSessions, _) {
              return ValueListenableBuilder(
                valueListenable: _stats.stats,
                builder: (_, stats, _) {
                  return ProfileLearningOverview(
                    stats: stats,
                    completedSessions: completedSessions,
                  );
                },
              );
            },
          ),
          const SizedBox(height: 24),
          _title('Learning Information'),
          const SizedBox(height: 8),
          ProfileInformationCard(profile: _profile),
          const SizedBox(height: 24),
          _title('Profile'),
          const SizedBox(height: 8),
          ProfileActionsCard(onEdit: _editProfile),
          if (_audience.allowsSignIn) ...[
            const SizedBox(height: 24),
            _title('Account'),
            const SizedBox(height: 8),
            AccountSection(authService: _auth, onSignIn: _openLogin),
          ],
        ],
      ),
    );
  }

  Widget _title(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
    );
  }
}
