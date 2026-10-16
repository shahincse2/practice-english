import 'package:flutter/material.dart';

/// Month and year pickers with nothing pre-selected, so the screen does not
/// hint at which answer is "right".
class BirthDateFields extends StatelessWidget {
  const BirthDateFields({
    super.key,
    required this.enabled,
    required this.onMonthChanged,
    required this.onYearChanged,
  });

  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  final bool enabled;
  final ValueChanged<int?> onMonthChanged;
  final ValueChanged<int?> onYearChanged;

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownMenu<int>(
          enabled: enabled,
          label: const Text('Month'),
          expandedInsets: EdgeInsets.zero,
          requestFocusOnTap: false,
          onSelected: onMonthChanged,
          dropdownMenuEntries: [
            for (var i = 0; i < _months.length; i++)
              DropdownMenuEntry(value: i + 1, label: _months[i]),
          ],
        ),
        const SizedBox(height: 16),
        DropdownMenu<int>(
          enabled: enabled,
          label: const Text('Year'),
          expandedInsets: EdgeInsets.zero,
          requestFocusOnTap: false,
          menuHeight: 320,
          onSelected: onYearChanged,
          dropdownMenuEntries: [
            for (var year = currentYear; year >= currentYear - 100; year--)
              DropdownMenuEntry(value: year, label: '$year'),
          ],
        ),
      ],
    );
  }
}
