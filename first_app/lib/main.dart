// main.dart
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'login_view.dart';
import 'register_view.dart';
import 'main_ui.dart';
import 'notes_view.dart';
import 'verify_email_view.dart';

void main() async {
  // Ensure Flutter is ready for native calls
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Auth using the Service
  await AuthService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
      routes: {
      '/login/': (context) => const LoginView(),
      '/register/': (context) => const RegisterView(),
      '/notes/': (context) => const NotesView(),
      '/verify-email/': (context) => const VerifyEmailView(),
    },
    );
  }
}
