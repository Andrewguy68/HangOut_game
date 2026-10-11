import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/validators.dart';

void main() {
  group('Validators.loginUsername', () {
    test('rejects null, empty and whitespace-only input', () {
      expect(Validators.loginUsername(null), 'Enter your username');
      expect(Validators.loginUsername(''), 'Enter your username');
      expect(Validators.loginUsername('   '), 'Enter your username');
    });

    test('accepts any non-empty username (no signup rules on log in)', () {
      expect(Validators.loginUsername('ameksa'), isNull);
      expect(Validators.loginUsername('a'), isNull);
    });
  });

  group('Validators.loginPassword', () {
    test('rejects null and empty input', () {
      expect(Validators.loginPassword(null), 'Enter your password');
      expect(Validators.loginPassword(''), 'Enter your password');
    });

    test('accepts any non-empty password', () {
      expect(Validators.loginPassword('x'), isNull);
      expect(Validators.loginPassword('  '), isNull);
    });
  });

  group('Validators.signupUsername', () {
    test('rejects null, empty and whitespace-only input', () {
      expect(Validators.signupUsername(null), 'Choose a username');
      expect(Validators.signupUsername(''), 'Choose a username');
      expect(Validators.signupUsername('   '), 'Choose a username');
    });

    test('rejects usernames shorter than 3 characters', () {
      expect(
        Validators.signupUsername('ab'),
        'Username must be at least 3 characters',
      );
    });

    test('rejects usernames longer than 20 characters', () {
      expect(
        Validators.signupUsername('a' * 21),
        'Username must be 20 characters or fewer',
      );
    });

    test('accepts the 3 and 20 character boundaries', () {
      expect(Validators.signupUsername('abc'), isNull);
      expect(Validators.signupUsername('a' * 20), isNull);
    });

    test('rejects spaces and symbols', () {
      const message = 'Use only letters, numbers and underscores';
      expect(Validators.signupUsername('bad name'), message);
      expect(Validators.signupUsername('a@b.com'), message);
      expect(Validators.signupUsername('name!'), message);
    });

    test('accepts letters, digits and underscores', () {
      expect(Validators.signupUsername('Ameksa_01'), isNull);
    });

    test('ignores surrounding whitespace', () {
      expect(Validators.signupUsername('  ameksa  '), isNull);
    });
  });

  group('Validators.signupPassword', () {
    test('rejects null and empty input', () {
      expect(Validators.signupPassword(null), 'Choose a password');
      expect(Validators.signupPassword(''), 'Choose a password');
    });

    test('rejects passwords shorter than 6 characters', () {
      expect(
        Validators.signupPassword('abcde'),
        'Password must be at least 6 characters',
      );
    });

    test('accepts passwords of 6 or more characters', () {
      expect(Validators.signupPassword('abcdef'), isNull);
      expect(Validators.signupPassword('a much longer passphrase'), isNull);
    });
  });
}
