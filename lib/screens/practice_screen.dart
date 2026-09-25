import 'package:flutter/material.dart';

import '../core/services/text_to_speech_service.dart';
import '../data/practice_data.dart';
import '../models/practice_question.dart';
import '../models/practice_type.dart';
import '../widgets/answer_result.dart';
import '../widgets/audio_button.dart';
import '../widgets/practice_header.dart';
import '../widgets/practice_inputs.dart';
import 'complete_screen.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final TextToSpeechService _tts = TextToSpeechService();

  int _questionIndex = 0;
  bool _checked = false;
  bool _correct = false;

  List<TextEditingController> _controllers = [];
  List<FocusNode> _focusNodes = [];

  PracticeQuestion get _question => practiceQuestions[_questionIndex];

  @override
  void initState() {
    super.initState();
    _createInputs();
    _initializeTts();
  }

  void _createInputs() {
    _disposeInputs();

    _controllers = List.generate(
      _question.words.length,
      (_) => TextEditingController(),
    );

    _focusNodes = List.generate(_question.words.length, (_) => FocusNode());
  }

  void _focusFirstInput() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _focusNodes.isEmpty) {
        return;
      }

      _focusNodes.first.requestFocus();
    });
  }

  Future<void> _initializeTts() async {
    final ready = await _tts.initialize();

    if (!ready || !mounted) {
      return;
    }

    await _tts.speak(_question.answer);
  }

  String _typeTitle() {
    switch (_question.type) {
      case PracticeType.word:
        return 'WORD';
      case PracticeType.twoWords:
        return 'TWO WORDS';
      case PracticeType.sentence:
        return 'SENTENCE';
    }
  }

  bool _allInputsFilled() {
    for (var i = 0; i < _question.words.length; i++) {
      if (_controllers[i].text.length != _question.words[i].length) {
        return false;
      }
    }

    return true;
  }

  bool _isCorrectAnswer() {
    for (var i = 0; i < _question.words.length; i++) {
      final expected = _question.words[i].toLowerCase();
      final actual = _controllers[i].text.trim().toLowerCase();

      if (expected != actual) {
        return false;
      }
    }

    return true;
  }

  void _handleChanged(int index, String value) {
    // একটি word পূর্ণ হলেও আর automatic next focus হবে না।
  }

  Future<void> _handleSpacePressed(int index) async {
    if (_correct) {
      return;
    }

    final currentWord = _question.words[index];

    // বর্তমান word পূর্ণ না হলে Spacebar দিয়ে সামনে যাওয়া যাবে না।
    if (_controllers[index].text.length != currentWord.length) {
      return;
    }

    // শেষ slot হলে এবং সব input পূর্ণ থাকলে answer check হবে।
    if (index >= _focusNodes.length - 1) {
      if (_allInputsFilled()) {
        await _checkFromKeyboard();
      }

      return;
    }

    // পরের slot-এ focus।
    _focusNodes[index + 1].requestFocus();
  }

  Future<void> _handleSubmitted(int index, String value) async {
    if (!_allInputsFilled()) {
      if (index < _focusNodes.length - 1) {
        _focusNodes[index + 1].requestFocus();
      }

      return;
    }

    await _checkFromKeyboard();
  }

  Future<void> _checkAnswer() async {
    FocusScope.of(context).unfocus();

    final correct = _isCorrectAnswer();

    setState(() {
      _checked = true;
      _correct = correct;
    });

    if (correct) {
      await Future<void>.delayed(const Duration(milliseconds: 300));

      if (mounted) {
        await _nextQuestion();
      }
    }
  }

  Future<void> _checkFromKeyboard() async {
    if (!_allInputsFilled()) {
      return;
    }

    await _checkAnswer();
  }

  Future<void> _nextQuestion() async {
    await _tts.stop();

    if (_questionIndex >= practiceQuestions.length - 1) {
      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CompleteScreen()),
      );

      return;
    }

    setState(() {
      _questionIndex++;
      _checked = false;
      _correct = false;
      _createInputs();
    });

    _focusFirstInput();

    await _tts.speak(_question.answer);
  }

  Future<void> _replay() async {
    await _tts.speak(_question.answer);
  }

  @override
  void dispose() {
    _tts.dispose();
    _disposeInputs();
    super.dispose();
  }

  void _disposeInputs() {
    for (final controller in _controllers) {
      controller.dispose();
    }

    for (final node in _focusNodes) {
      node.dispose();
    }

    _controllers = [];
    _focusNodes = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Practice')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            children: [
              PracticeHeader(
                type: _typeTitle(),
                current: _questionIndex + 1,
                total: practiceQuestions.length,
              ),
              const SizedBox(height: 28),
              AudioButton(onPressed: _replay),
              const SizedBox(height: 40),
              PracticeInputs(
                question: _question,
                controllers: _controllers,
                focusNodes: _focusNodes,
                enabled: !_correct,
                isChecked: _checked,
                onChanged: _handleChanged,
                onSubmitted: _handleSubmitted,
                onSpacePressed: _handleSpacePressed,
              ),
              const SizedBox(height: 36),
              if (!_correct) _buildCheckButton(),
              if (_checked) ...[
                const SizedBox(height: 24),
                AnswerResult(correct: _correct),
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
