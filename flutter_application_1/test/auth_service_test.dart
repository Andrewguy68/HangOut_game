import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/auth_service.dart';

// The calls that talk to Firebase (signUp, logIn, logOut) are covered by
// integration_test/auth_test.dart against the real project. These tests cover
// the pure logic around them.
void main() {
  group('AuthService.toEmail', () {
    test('lowercases and trims the username', () {
      expect(AuthService.toEmail('  AmEksa '), 'ameksa@myapp.example');
    });

    test('keeps digits and underscores', () {
      expect(AuthService.toEmail('user_01'), 'user_01@myapp.example');
    });

    test('maps usernames that differ only by case to the same email', () {
      expect(AuthService.toEmail('Ameksa'), AuthService.toEmail('aMEKSA'));
    });
  });

  group('authErrorMessage', () {
    const knownCodes = <String, String>{
      'email-already-in-use': 'That username is already taken.',
      'weak-password': 'That password is too weak. Use at least 6 characters.',
      'invalid-email':
          "That username isn't valid. Use letters, numbers and underscores.",
      'user-not-found': 'Incorrect username or password.',
      'wrong-password': 'Incorrect username or password.',
      'invalid-credential': 'Incorrect username or password.',
      'user-disabled': 'This account has been disabled.',
      'too-many-requests': 'Too many attempts. Please wait a bit and try again.',
      'network-request-failed':
          'No internet connection. Check your network and try again.',
      'operation-not-allowed':
          'Email/password sign-in is not enabled for this project.',
    };

    knownCodes.forEach((code, message) {
      test('maps $code', () {
        expect(authErrorMessage(FirebaseAuthException(code: code)), message);
      });
    });

    test('gives a generic message for unknown auth codes', () {
      expect(
        authErrorMessage(FirebaseAuthException(code: 'something-new')),
        'Authentication failed. Please try again.',
      );
    });

    test('maps other Firebase errors (e.g. Firestore) to a server message', () {
      expect(
        authErrorMessage(
          FirebaseException(plugin: 'cloud_firestore', code: 'unavailable'),
        ),
        'Could not reach the server. Please try again.',
      );
    });

    test('gives a generic message for anything else', () {
      expect(
        authErrorMessage(StateError('boom')),
        'Something went wrong. Please try again.',
      );
    });
  });
}