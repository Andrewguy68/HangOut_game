import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  String _toEmail(String username) =>
      '${username.trim().toLowerCase()}@myapp.example';

  Stream<User?> get authState => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<User> signUp(String username, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: _toEmail(username),
      password: password, // min 6 chars
    );
    final user = cred.user!;
    await _db.collection('users').doc(user.uid).set({
      'username': username.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    return user;
  }

  Future<User> logIn(String username, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: _toEmail(username),
      password: password,
    );
    return cred.user!;
  }

  Future<void> logOut() => _auth.signOut();
}
