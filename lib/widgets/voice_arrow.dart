import 'package:flutter/material.dart';

class VoiceArrow extends StatelessWidget {
  const VoiceArrow({super.key, required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onPressed, icon: Icon(icon, size: 32));
  }
}
