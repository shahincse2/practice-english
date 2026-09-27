import 'package:flutter/material.dart';

import '../controllers/practice_controller.dart';
import '../data/datasources/json_practice_data_source.dart';
import '../data/repositories/practice_repository_impl.dart';
import '../widgets/answer_result.dart';
import '../widgets/audio_button.dart';
import '../widgets/practice_header.dart';
import '../widgets/practice_inputs.dart';
import 'complete_screen.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key, this.segment, this.level});

  final String? segment;
  final String? level;

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  late final PracticeController _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _controller = PracticeController(
      PracticeRepositoryImpl(const JsonPracticeDataSource()),
    );

    _initialize();
  }

  Future<void> _initialize() async {
    await _controller.initialize(segment: widget.segment, level: widget.level);

    if (!mounted) return;

    setState(() {
      _loading = false;
    });

    if (_controller.hasQuestions) {
      _controller.focusFirstInput();
    }
  }

  Future<void> _checkAnswer() async {
    await _controller.checkAnswer();

    if (!mounted) return;

    setState(() {});

    if (_controller.correct) {
      await Future<void>.delayed(const Duration(milliseconds: 300));

      if (mounted) {
        await _goNext();
      }
    }
  }

  Future<void> _goNext() async {
    if (_controller.index >= _controller.questions.length - 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CompleteScreen()),
      );
      return;
    }

    await _controller.nextQuestion();

    if (!mounted) return;

    setState(() {});
    _controller.focusFirstInput();
  }

  Future<void> _handleSpace(int index) async {
    if (_controller.correct) return;

    final word = _controller.question.words[index];

    if (_controller.controllers[index].text.length != word.length) {
      return;
    }

    if (index == _controller.focusNodes.length - 1) {
      if (_controller.allInputsFilled()) {
        await _checkAnswer();
      }
      return;
    }

    _controller.focusNodes[index + 1].requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_controller.hasQuestions) {
      return _buildEmptyState();
    }

    return _buildPractice();
  }

  Widget _buildEmptyState() {
    return Scaffold(
      appBar: AppBar(title: const Text('Practice')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.menu_book_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 20),
              const Text(
                'No Practice Available',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'There are no questions available '
                'for this selection.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Choose Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPractice() {
    return Scaffold(
      appBar: AppBar(title: const Text('Practice')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            children: [
              PracticeHeader(
                type: _controller.typeTitle(),
                current: _controller.index + 1,
                total: _controller.questions.length,
              ),
              const SizedBox(height: 28),
              AudioButton(onPressed: _controller.replay),
              const SizedBox(height: 40),
              PracticeInputs(
                question: _controller.question,
                controllers: _controller.controllers,
                focusNodes: _controller.focusNodes,
                enabled: !_controller.correct,
                isChecked: _controller.checked,
                onChanged: (_, __) {},
                onSubmitted: (_, __) => _checkAnswer(),
                onSpacePressed: _handleSpace,
              ),
              const SizedBox(height: 36),
              if (!_controller.correct) _buildCheckButton(),
              if (_controller.checked) ...[
                const SizedBox(height: 24),
                AnswerResult(correct: _controller.correct),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: _checkAnswer,
        child: const Text('Check Answer'),
      ),
    );
  }
}
