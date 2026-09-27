import 'package:flutter/material.dart';
import 'package:practice_english/screens/practice_level_screen.dart';

import '../data/datasources/json_practice_data_source.dart';
import '../data/practice_catalog.dart';
import '../data/repositories/practice_repository_impl.dart';
import '../models/practice_level.dart';
import '../models/practice_segment.dart';
import '../widgets/practice_selection_card.dart';

class PracticeSetupScreen extends StatefulWidget {
  const PracticeSetupScreen({super.key});

  @override
  State<PracticeSetupScreen> createState() => _PracticeSetupScreenState();
}

class _PracticeSetupScreenState extends State<PracticeSetupScreen> {
  final _repository = PracticeRepositoryImpl(const JsonPracticeDataSource());

  Map<String, int> _questionCounts = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestionCounts();
  }

  Future<void> _loadQuestionCounts() async {
    final questions = await _repository.getQuestions();
    final counts = <String, int>{};

    for (final question in questions) {
      final key = '${question.segment.name}:${question.level.name}';
      counts[key] = (counts[key] ?? 0) + 1;
    }

    if (!mounted) return;

    setState(() {
      _questionCounts = counts;
      _loading = false;
    });
  }

  int _questionCount(PracticeSegment segment, PracticeLevel level) {
    return _questionCounts['${segment.name}:${level.name}'] ?? 0;
  }

  int _segmentQuestionCount(PracticeSegment segment) {
    return PracticeCatalog.levels[segment]!.fold(
      0,
      (total, level) => total + _questionCount(segment, level),
    );
  }

  void _selectSegment(PracticeSegment segment) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PracticeLevelScreen(
          segment: segment,
          questionCounts: _questionCounts,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Choose Practice')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Choose Practice')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'What do you want to practice?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text('Choose a category to see available levels.'),
          const SizedBox(height: 24),
          _buildSegments(),
        ],
      ),
    );
  }

  Widget _buildSegments() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: PracticeSegment.values.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.45,
      ),
      itemBuilder: (context, index) {
        final segment = PracticeSegment.values[index];

        return PracticeSelectionCard(
          title: PracticeCatalog.segmentName(segment),
          subtitle: '${_segmentQuestionCount(segment)} questions',
          onTap: () => _selectSegment(segment),
        );
      },
    );
  }
}
