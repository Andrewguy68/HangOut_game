import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/auth_service.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  testWidgets('sign up, log out, log in, then clean up', (tester) async {
    final auth = AuthService();
    // unique name per run so the test is repeatable
    final username = 'test_${DateTime.now().millisecondsSinceEpoch}';
    const password = 'secret123';

    // sign up
    final created = await auth.signUp(username, password);
    expect(auth.currentUser?.uid, created.uid);

    // profile doc was written with the right username
    final db = FirebaseFirestore.instance;
    final doc = await db.collection('users').doc(created.uid).get();
    expect(doc.exists, isTrue);
    expect(doc.data()?['username'], username);

    // log out, log back in, same uid
    await auth.logOut();
    expect(auth.currentUser, isNull);
    final loggedIn = await auth.logIn(username, password);
    expect(loggedIn.uid, created.uid);

    // wrong password is rejected
    await auth.logOut();
    await expectLater(
      auth.logIn(username, 'wrongpass'),
      throwsA(isA<FirebaseAuthException>()),
    );

    // clean up: delete the profile doc, then the auth user
    final user = await auth.logIn(username, password);
    await db.collection('users').doc(user.uid).delete();
    await user.delete();
  });
}
