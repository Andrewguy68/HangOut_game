import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'auth_gate.dart';
import 'auth_scope.dart';
import 'auth_service.dart';
import 'Storage/word_scope.dart';
import 'Storage/word_service.dart';
import 'Storage/word_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final authService = AuthService();
  runApp(
    MyApp(
      authService: authService,
      wordService: WordService(storage: WordStorage(), auth: authService),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.authService,
    required this.wordService,
  });

  final AuthService authService;
  final WordService wordService;

  @override
  Widget build(BuildContext context) {
    return AuthScope(
      service: authService,
      child: WordScope(
        service: wordService,
        child: MaterialApp(
          title: 'Hang-Out!',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange, primary: const Color.fromARGB(255, 181, 26, 26), secondary: const Color.fromARGB(236, 249, 116, 55)),
            useMaterial3: true,
            textTheme: TextTheme(
              headlineLarge: GoogleFonts.honk(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
              headlineMedium: GoogleFonts.honk(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
              headlineSmall: GoogleFonts.honk(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          home: const AuthGate(),
        ),
      ),
    );
  }
}
