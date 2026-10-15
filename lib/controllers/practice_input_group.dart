import 'package:flutter/material.dart';

/// Owns the per-word text controllers and focus nodes of one question.
///
/// Kept separate from [PracticeController] so any practice mode
/// (word, phrase, sentence, sentence-building) can reuse the same
/// typing-input logic.
class PracticeInputGroup {
  List<TextEditingController> controllers = [];
  List<FocusNode> focusNodes = [];

  // Replaced inputs can still be attached to widgets that are on screen
  // until the UI switches to the new ones, so they are disposed later.
  final List<ChangeNotifier> _retired = [];

  /// Creates [count] fresh inputs and retires the previous ones.
  void rebuild(int count) {
    _retireCurrent();

    controllers = List.generate(
      count,
      (_) => TextEditingController(),
    );
    focusNodes = List.generate(
      count,
      (_) => FocusNode(),
    );
  }

  void focusFirst() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (focusNodes.isNotEmpty) {
        focusNodes.first.requestFocus();
      }
    });
  }

  bool allFilled(List<String> words) {
    for (var i = 0; i < words.length; i++) {
      if (controllers[i].text.length != words[i].length) {
        return false;
      }
    }
    return true;
  }

  bool matches(List<String> words) {
    for (var i = 0; i < words.length; i++) {
      if (controllers[i].text.trim().toLowerCase() !=
          words[i].toLowerCase()) {
        return false;
      }
    }
    return true;
  }

  String get text => controllers.map((item) => item.text.trim()).join(' ');

  /// Disposes inputs replaced by [rebuild]; call it once the UI shows the
  /// new ones (for example in a post-frame callback).
  void disposeRetired() {
    for (final item in _retired) {
      item.dispose();
    }
    _retired.clear();
  }

  void dispose() {
    _retireCurrent();
    disposeRetired();
  }

  void _retireCurrent() {
    _retired
      ..addAll(controllers)
      ..addAll(focusNodes);

    controllers = [];
    focusNodes = [];
  }
}
