import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'login_view.dart';
import 'notes_view.dart';
import 'verify_email_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;

    if (user != null) {
      if (user.emailVerified) {
        return const NotesView();
      } else {
        return const VerifyEmailView();
      }
    } else {
      return const LoginView();
    }
  }
}
