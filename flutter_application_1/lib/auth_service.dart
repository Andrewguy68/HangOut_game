import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' show FirebaseException;

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  static String toEmail(String username) =>
      '${username.trim().toLowerCase()}@myapp.example';

  Stream<User?> get authState => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<User> signUp(String username, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: toEmail(username),
      password: password, // min 6 chars
    );
    final user = cred.user!;
    try {
      await _db.collection('users').doc(user.uid).set({
        'username': username.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {
      try {
        await user.delete();
      } catch (_) {}
      rethrow;
    }
    return user;
  }

  Future<User> logIn(String username, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: toEmail(username),
      password: password,
    );
    return cred.user!;
  }

  Future<void> logOut() => _auth.signOut();
}

String authErrorMessage(Object error) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'That username is already taken.';
      case 'weak-password':
        return 'That password is too weak. Use at least 6 characters.';
      case 'invalid-email':
        return "That username isn't valid. Use letters, numbers and underscores.";
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect username or password.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a bit and try again.';
      case 'network-request-failed':
        return 'No internet connection. Check your network and try again.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled for this project.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
  if (error is FirebaseException) {
    return 'Could not reach the server. Please try again.';
  }
  return 'Something went wrong. Please try again.';
}
