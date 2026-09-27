class AudioSettings {
  const AudioSettings({
    this.voiceName,
    this.voiceLocale = 'en-US',
    this.speechRate = 0.42,
    this.speechVolume = 1.0,
    this.correctVolume = 1.0,
    this.wrongVolume = 1.0,
  });

  final String? voiceName;
  final String voiceLocale;
  final double speechRate;
  final double speechVolume;
  final double correctVolume;
  final double wrongVolume;

  AudioSettings copyWith({
    String? voiceName,
    String? voiceLocale,
    double? speechRate,
    double? speechVolume,
    double? correctVolume,
    double? wrongVolume,
  }) {
    return AudioSettings(
      voiceName: voiceName ?? this.voiceName,
      voiceLocale: voiceLocale ?? this.voiceLocale,
      speechRate: speechRate ?? this.speechRate,
      speechVolume: speechVolume ?? this.speechVolume,
      correctVolume: correctVolume ?? this.correctVolume,
      wrongVolume: wrongVolume ?? this.wrongVolume,
    );
  }
}