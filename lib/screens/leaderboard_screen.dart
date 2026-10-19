import 'dart:async';

import 'package:flutter/material.dart';

import '../core/api/api_exception.dart';
import '../core/api/default_account_service.dart';
import '../core/api/default_practice_services.dart';
import '../core/auth/default_auth_service.dart';
import '../core/sessions/session_reporter.dart';
import '../models/app_user.dart';
import '../models/leaderboard_page.dart';
import '../models/leaderboard_period.dart';
import '../widgets/leaderboard_content.dart';
import '../widgets/leaderboard_period_filter.dart';
import '../widgets/leaderboard_preview_notice.dart';
import 'account_setup_flow.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final _service = defaultLeaderboardService();
  final _auth = defaultAuthService();

  StreamSubscription<AppUser?>? _authSubscription;
  LeaderboardPeriod _period = LeaderboardPeriod.weekly;
  LeaderboardPage? _page;
  bool _loading = true;
  String? _error;
  int _request = 0;

  @override
  void initState() {
    super.initState();
    // Reload when the user signs in or out, so "your rank" stays right.
    _authSubscription = _auth?.userChanges.listen((_) => _load());
    _load();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    final request = ++_request;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // Upload finished sessions first, so they are part of the ranking.
      await SessionReporter.instance.flushPending();
      final page = await _service.load(_period);
      if (mounted && request == _request) setState(() => _page = page);
    } on ApiException catch (error) {
      debugPrint('Loading the leaderboard failed: $error');
      if (mounted && request == _request) setState(() => _error = error.message);
    } catch (error) {
      debugPrint('Loading the leaderboard failed: $error');
      if (mounted && request == _request) {
        setState(() => _error = 'Something went wrong. Please try again.');
      }
    } finally {
      if (mounted && request == _request) setState(() => _loading = false);
    }
  }

  void _changePeriod(LeaderboardPeriod value) {
    setState(() => _period = value);
    _load();
  }

  Future<void> _signIn() async {
    final signedIn = await signInAndSetup(
      context,
      auth: _auth,
      profiles: defaultAccountProfileService(),
    );
    if (!mounted) return;

    if (_auth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign-in is not available here.')),
      );
    } else if (signedIn) {
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = _page;

    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _load,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              Text(
                'Learn, improve, and climb the ranks.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              if (page != null && page.isPreview) ...[
                const LeaderboardPreviewNotice(),
                const SizedBox(height: 16),
              ],
              LeaderboardPeriodFilter(
                selected: _period,
                onChanged: _changePeriod,
              ),
              const SizedBox(height: 18),
              LeaderboardContent(
                page: page,
                loading: _loading,
                error: _error,
                signedIn: _auth?.currentUser != null,
                onSignIn: _signIn,
                onRetry: _load,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
