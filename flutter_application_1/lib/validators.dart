/// checks shared by the Login and Signup
/// each method returns an error message to show under the field, or null when
/// the value is fine
class Validators {
  Validators._();

  static final RegExp _usernameChars = RegExp(r'^[A-Za-z0-9_]+$');

  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 20;
  static const int minPasswordLength = 6; // Firebase's minimum

  /// Log in only checks that something was typed, so an existing account is
  /// never locked out
  static String? loginUsername(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter your username';
    return null;
  }

  static String? loginPassword(String? value) {
    if (value == null || value.isEmpty) return 'Enter your password';
    return null;
  }

  static String? signupUsername(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Choose a username';
    if (name.length < minUsernameLength) {
      return 'Username must be at least $minUsernameLength characters';
    }
    if (name.length > maxUsernameLength) {
      return 'Username must be $maxUsernameLength characters or fewer';
    }
    if (!_usernameChars.hasMatch(name)) {
      return 'Use only letters, numbers and underscores';
    }
    return null;
  }

  static String? signupPassword(String? value) {
    if (value == null || value.isEmpty) return 'Choose a password';
    if (value.length < minPasswordLength) {
      return 'Password must be at least $minPasswordLength characters';
    }
    return null;
  }
}
