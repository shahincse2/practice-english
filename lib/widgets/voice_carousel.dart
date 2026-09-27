import 'package:flutter/material.dart';

import 'voice_arrow.dart';
import 'voice_dots.dart';
import 'voice_page.dart';

class VoiceCarousel extends StatefulWidget {
  const VoiceCarousel({
    super.key,
    required this.voices,
    required this.selectedName,
    required this.onPageChanged,
    required this.onPreview,
  });

  final List<Map<String, String>> voices;
  final String? selectedName;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<Map<String, String>> onPreview;

  @override
  State<VoiceCarousel> createState() => _VoiceCarouselState();
}

class _VoiceCarouselState extends State<VoiceCarousel> {
  late final PageController _controller;

  int _currentPage = 0;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setInitialPage();
    });
  }

  void _setInitialPage() {
    if (!mounted || widget.voices.isEmpty) return;

    final index = widget.voices.indexWhere(
          (voice) => voice['name'] == widget.selectedName,
    );

    if (index >= 0) {
      _currentPage = index;
      _controller.jumpToPage(index);
      widget.onPageChanged(index);
    }

    if (mounted) {
      setState(() => _ready = true);
    }
  }

  void _handlePageChanged(int index) {
    if (!mounted) return;

    setState(() => _currentPage = index);
    widget.onPageChanged(index);

    if (_ready) {
      widget.onPreview(widget.voices[index]);
    }
  }

  Future<void> _move(int direction) async {
    final target = _currentPage + direction;

    if (target < 0 || target >= widget.voices.length) return;

    await _controller.animateToPage(
      target,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.voices.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: 280,
          child: Row(
            children: [
              VoiceArrow(
                icon: Icons.chevron_left_rounded,
                onPressed: () => _move(-1),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: widget.voices.length,
                  onPageChanged: _handlePageChanged,
                  itemBuilder: (_, index) {
                    return VoicePage(
                      voice: widget.voices[index],
                      selected:
                      widget.voices[index]['name'] == widget.selectedName,
                    );
                  },
                ),
              ),
              VoiceArrow(
                icon: Icons.chevron_right_rounded,
                onPressed: () => _move(1),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        VoiceDots(
          count: widget.voices.length,
          currentPage: _currentPage,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}