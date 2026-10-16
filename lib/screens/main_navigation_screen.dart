import 'package:flutter/material.dart';

import '../core/audience/audience_service.dart';
import 'dashboard_screen.dart';
import 'home_screen.dart';
import 'leaderboard_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _Tab {
  const _Tab(this.screen, this.destination);

  final Widget screen;
  final NavigationDestination destination;
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _index = 0;

  final _audience = AudienceService.instance.current;

  late final List<_Tab> _tabs = [
    const _Tab(
      HomeScreen(),
      NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home_rounded),
        label: 'Home',
      ),
    ),
    const _Tab(
      DashboardScreen(),
      NavigationDestination(
        icon: Icon(Icons.bar_chart_outlined),
        selectedIcon: Icon(Icons.bar_chart_rounded),
        label: 'Dashboard',
      ),
    ),
    if (_audience.allowsLeaderboard)
      const _Tab(
        LeaderboardScreen(),
        NavigationDestination(
          icon: Icon(Icons.emoji_events_outlined),
          selectedIcon: Icon(Icons.emoji_events_rounded),
          label: 'Leaderboard',
        ),
      ),
    const _Tab(
      SettingsScreen(),
      NavigationDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings_rounded),
        label: 'Settings',
      ),
    ),
    const _Tab(
      ProfileScreen(),
      NavigationDestination(
        icon: Icon(Icons.person_outline_rounded),
        selectedIcon: Icon(Icons.person_rounded),
        label: 'Profile',
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [for (final tab in _tabs) tab.screen],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: [for (final tab in _tabs) tab.destination],
      ),
    );
  }
}
