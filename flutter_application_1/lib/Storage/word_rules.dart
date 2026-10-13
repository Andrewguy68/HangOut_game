/// Thrown with a message that is safe to show to the user.
class WordException implements Exception {
  const WordException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Pure rules for the word a player adds: what it may look like, and how long
/// a player has to wait between words.
class WordRules {
  WordRules._();

  static const int minLength = 3;
  static const int maxLength = 15;
  static const Duration cooldown = Duration(hours: 24);

  static final RegExp _letters = RegExp(r'^[a-z]+$');

  /// Words are stored trimmed and lowercase.
  static String normalize(String raw) => raw.trim().toLowerCase();

  /// An error message to show, or null when [raw] has an acceptable shape.
  static String? validate(String? raw) {
    final word = normalize(raw ?? '');
    if (word.isEmpty) return 'Enter a word';
    if (!_letters.hasMatch(word)) {
      return 'Use letters A-Z only (no spaces, numbers or symbols)';
    }
    if (word.length < minLength) {
      return 'Word must be at least $minLength letters';
    }
    if (word.length > maxLength) {
      return 'Word must be $maxLength letters or fewer';
    }
    return null;
  }

  /// How much longer the player must wait before adding another word.
  /// [Duration.zero] means they can add one now.
  static Duration cooldownRemaining(DateTime? lastSubmittedAt, DateTime now) {
    if (lastSubmittedAt == null) return Duration.zero;
    var remaining = lastSubmittedAt.add(cooldown).difference(now);
    if (remaining.isNegative) return Duration.zero;
    if (remaining > cooldown) remaining = cooldown;
    return remaining;
  }

  /// "5h 12m", "22h", "45m". Rounds up so we never say "0m" while waiting.
  static String formatRemaining(Duration remaining) {
    final totalMinutes = (remaining.inSeconds / 60).ceil();
    if (totalMinutes <= 0) return 'less than a minute';
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (hours == 0) return '${minutes}m';
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}m';
  }

  static String cooldownMessage(Duration remaining) =>
      "You've already added a word. "
      'You can add another in ${formatRemaining(remaining)}.';
}
