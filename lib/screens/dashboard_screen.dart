import 'package:flutter/material.dart';

import '../core/services/practice_history_service.dart';
import '../core/services/practice_stats_service.dart';
import '../models/practice_stats.dart';
import '../models/practice_type.dart';
import '../widgets/dashboard_summary_card.dart';
import '../widgets/practice_type_stats_card.dart';
import '../widgets/recent_activity_section.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _statsService = PracticeStatsService.instance;
  final _historyService = PracticeHistoryService.instance;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _statsService.initialize();
    await _historyService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: ValueListenableBuilder<PracticeStats>(
        valueListenable: _statsService.stats,
        builder: (context, stats, _) {
          return RefreshIndicator(
            onRefresh: _initialize,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: [
                DashboardSummaryCard(stats: stats),
                const SizedBox(height: 20),
                _sectionTitle('Practice by Type'),
                const SizedBox(height: 20),
                _sectionTitle('Recent Activity'),
                const SizedBox(height: 12),
                ValueListenableBuilder(
                  valueListenable: _historyService.history,
                  builder: (context, history, _) {
                    return RecentActivitySection(items: history);
                  },
                ),
                const SizedBox(height: 12),
                _typeCard('Word', PracticeType.word, stats.word),
                _typeCard('Phrase', PracticeType.phrase, stats.phrase),
                _typeCard('Sentence', PracticeType.sentence, stats.sentence),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
    );
  }

  Widget _typeCard(String title, PracticeType type, PracticeTypeStats stats) {
    return PracticeTypeStatsCard(title: title, type: type, stats: stats);
  }
}
