import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WordInput extends StatelessWidget {
  const WordInput({
    super.key,
    required this.controller,
    required this.target,
    required this.enabled,
    required this.isChecked,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
    required this.onSpacePressed,
  });

  final TextEditingController controller;
  final String target;
  final bool enabled;
  final bool isChecked;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onSpacePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = (target.length * 14.0 + 30).clamp(40.0, 150.0);

    return SizedBox(
      width: width,
      child: CallbackShortcuts(
        bindings: <ShortcutActivator, VoidCallback>{
          const SingleActivator(LogicalKeyboardKey.space): onSpacePressed,
        },
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          maxLength: target.length + 1,
          textAlign: TextAlign.center,
          textInputAction: TextInputAction.next,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          inputFormatters: [
            _WordInputFormatter(
              maxLetters: target.length,
              onSpace: onSpacePressed,
            ),
          ],
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            counterText: '',
            contentPadding: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
            enabledBorder: _border(_borderColor(theme)),
            focusedBorder: _border(theme.colorScheme.primary, width: 2),
            disabledBorder: _border(_borderColor(theme)),
          ),
        ),
      ),
    );
  }

  Color _borderColor(ThemeData theme) {
    if (!isChecked) {
      return theme.colorScheme.outline;
    }

    return controller.text.trim().toLowerCase() == target.toLowerCase()
        ? Colors.green
        : Colors.red;
  }

  UnderlineInputBorder _border(Color color, {double width = 1}) {
    return UnderlineInputBorder(
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

class _WordInputFormatter extends TextInputFormatter {
  _WordInputFormatter({required this.maxLetters, required this.onSpace});

  final int maxLetters;
  final VoidCallback onSpace;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final value = newValue.text;

    if (value.contains(' ')) {
      final beforeSpace = value.split(' ').first;

      if (beforeSpace.length == maxLetters) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          onSpace();
        });
      }

      return newValue.copyWith(
        text: beforeSpace,
        selection: TextSelection.collapsed(offset: beforeSpace.length),
      );
    }

    final lettersOnly = value.replaceAll(RegExp(r'[^a-zA-Z]'), '');

    if (lettersOnly.length > maxLetters) {
      return oldValue;
    }

    return newValue.copyWith(
      text: lettersOnly,
      selection: TextSelection.collapsed(offset: lettersOnly.length),
    );
  }
}
