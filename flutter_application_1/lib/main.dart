import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'auth_gate.dart';
import 'auth_scope.dart';
import 'auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp(authService: AuthService()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.authService});

  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    return AuthScope(
      service: authService,
      child: MaterialApp(
        title: 'Hang-Out!',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          useMaterial3: true,
        ),
        home: const AuthGate(),
      ),
    );
  }
}
