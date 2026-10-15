class TranslationSettings {
  const TranslationSettings({
    this.languageCode = 'bn',
    this.showDuringPractice = true,
  });

  final String languageCode;
  final bool showDuringPractice;

  TranslationSettings copyWith({
    String? languageCode,
    bool? showDuringPractice,
  }) {
    return TranslationSettings(
      languageCode: languageCode ?? this.languageCode,
      showDuringPractice:
          showDuringPractice ?? this.showDuringPractice,
    );
  }
}
