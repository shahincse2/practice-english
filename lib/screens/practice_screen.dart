import 'dart:async';

import 'package:flutter/material.dart';

import '../controllers/practice_controller.dart';
import '../core/services/interstitial_ad_service.dart';
import '../core/services/practice_session_service.dart';
import '../core/services/telemetry_service.dart';
import '../core/utils/run_once.dart';
import '../data/datasources/default_practice_data_source.dart';
import '../data/repositories/practice_repository_impl.dart';
import '../models/practice_segment.dart';
import '../widgets/loading_scaffold.dart';
import '../widgets/practice_empty_state.dart';
import '../widgets/practice_question_view.dart';
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
  final _sessions = PracticeSessionService.instance;
  final _telemetry = TelemetryService.instance;
  final _check = RunOnce();
  final _next = RunOnce();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _telemetry.setKidsMode(widget.segment == PracticeSegment.kids.name);
    _controller = PracticeController(
      PracticeRepositoryImpl(defaultPracticeDataSource()),
    );
    _initialize();
  }

  Future<void> _initialize() async {
    await _controller.initialize(segment: widget.segment, level: widget.level);
    await _sessions.initialize();

    if (!mounted) return;
    setState(() => _loading = false);

    if (_controller.hasQuestions) {
      _controller.focusFirstInput();
    }
  }

  Future<void> _checkAnswer() => _check(_performCheck);

  Future<void> _goNext() => _next(_performNext);

  Future<void> _performCheck() async {
    await _controller.checkAnswer();
    if (!mounted) return;
    setState(() {});

    if (_controller.correct) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      if (mounted) await _goNext();
    }
  }

  Future<void> _showAnswer() async {
    await _controller.revealAnswer();
    if (mounted) setState(() {});
  }

  Future<void> _performNext() async {
    if (_controller.index >= _controller.questions.length - 1) {
      await _sessions.recordCompletedSession();
      unawaited(_telemetry.sessionCompleted(widget.segment, widget.level));
      await InterstitialAdService.instance.showAfterCompletedSession(
        _sessions.completedSessions.value,
      );

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CompleteScreen()),
      );
      return;
    }

    await _controller.nextQuestion();

    if (!mounted) return;
    setState(() {});
    _controller.focusFirstInput();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _controller.releaseRetiredInputs(),
    );
  }

  Future<void> _handleSpace(int index) async {
    if (_controller.correct || _controller.answerRevealed) return;

    final word = _controller.question.words[index];
    final input = _controller.controllers[index].text;

    if (input.length != word.length) return;

    if (index == _controller.focusNodes.length - 1) {
      if (_controller.allInputsFilled()) await _checkAnswer();
      return;
    }

    _controller.focusNodes[index + 1].requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _telemetry.setKidsMode(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const LoadingScaffold();

    if (!_controller.hasQuestions) return const PracticeEmptyState();
    return _practice();
  }

  Widget _practice() {
    return Scaffold(
      appBar: AppBar(title: const Text('Practice')),
      body: PracticeQuestionView(
        controller: _controller,
        onCheck: _checkAnswer,
        onShowAnswer: _showAnswer,
        onContinue: _goNext,
        onSpacePressed: _handleSpace,
      ),
    );
  }
}
