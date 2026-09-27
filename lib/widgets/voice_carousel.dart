import 'package:flutter/material.dart';

class VoiceCarousel extends StatefulWidget {
  const VoiceCarousel({
    super.key,
    required this.controller,
    required this.voices,
    required this.selectedName,
    required this.onPreview,
  });

  final PageController controller;
  final List<Map<String, String>> voices;
  final String? selectedName;
  final ValueChanged<Map<String, String>> onPreview;

  @override
  State<VoiceCarousel> createState() => _VoiceCarouselState();
}

class _VoiceCarouselState extends State<VoiceCarousel> {
  int _currentPage = 0;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
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

      if (widget.controller.hasClients) {
        widget.controller.jumpToPage(index);
      }
    }

    if (mounted) {
      setState(() => _ready = true);
    }
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
              _Arrow(
                icon: Icons.chevron_left_rounded,
                onPressed: () => _move(-1),
              ),
              Expanded(
                child: PageView.builder(
                  controller: widget.controller,
                  itemCount: widget.voices.length,
                  onPageChanged: _handlePageChanged,
                  itemBuilder: (_, index) {
                    return _VoicePage(
                      voice: widget.voices[index],
                      selected:
                          widget.voices[index]['name'] == widget.selectedName,
                    );
                  },
                ),
              ),
              _Arrow(
                icon: Icons.chevron_right_rounded,
                onPressed: () => _move(1),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        _Dots(count: widget.voices.length, currentPage: _currentPage),
      ],
    );
  }

  void _handlePageChanged(int index) {
    if (!mounted) return;

    setState(() => _currentPage = index);

    if (_ready) {
      widget.onPreview(widget.voices[index]);
    }
  }

  Future<void> _move(int direction) async {
    final target = _currentPage + direction;

    if (target < 0 || target >= widget.voices.length) {
      return;
    }

    await widget.controller.animateToPage(
      target,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }
}

class _VoicePage extends StatelessWidget {
  const _VoicePage({required this.voice, required this.selected});

  final Map<String, String> voice;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 68,
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            Icons.record_voice_over_rounded,
            size: 54,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _friendlyName(),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        Text(
          _description(),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: theme.colorScheme.secondary),
        ),
        const SizedBox(height: 8),
        if (selected)
          Icon(
            Icons.check_circle_rounded,
            color: theme.colorScheme.primary,
            size: 22,
          ),
      ],
    );
  }

  String _friendlyName() {
    final name = voice['name'] ?? '';
    final locale = voice['locale'] ?? '';

    if (name == 'en-US-default') return 'English (US)';
    if (name == 'en-IN-default') return 'English (India)';
    if (name == 'en-US-SMTf00') return 'English (US) Enhanced';
    if (name == 'en-IN-SMTf00') return 'English (India) Enhanced';
    if (locale == 'en-US') return 'English (US)';
    if (locale == 'en-GB') return 'English (UK)';

    return name.isEmpty ? 'English Voice' : name;
  }

  String _description() {
    final name = voice['name'] ?? '';

    if (name.contains('SMTf00')) {
      return 'Enhanced English voice';
    }

    if (name.contains('default')) {
      return 'Standard English voice';
    }

    return voice['locale'] ?? 'English voice';
  }
}

class _Arrow extends StatelessWidget {
  const _Arrow({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onPressed, icon: Icon(icon, size: 32));
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.currentPage});

  final int count;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    final active = Theme.of(context).colorScheme.primary;
    final inactive = Theme.of(context).colorScheme.outlineVariant;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == currentPage ? active : inactive,
          ),
        ),
      ),
    );
  }
}
