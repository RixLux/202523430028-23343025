//login_view.dart

import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'register_view.dart';
import 'verify_email_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _email,
              decoration: const InputDecoration(hintText: 'Enter email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _password,
              decoration: const InputDecoration(hintText: 'Enter password'),
              obscureText: true,
            ),

            // Login Button with Firebase
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;

                try {
                  await AuthService().signIn(
                    email: email,
                    password: password,
                  );

                  await AuthService().reloadUser();
                  final freshUser = AuthService().currentUser;

                  if (!mounted) return;

                  // succesful login :)
                  if (freshUser?.emailVerified ?? false) {
                    // SUCCESS: Email is verified
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/notes/',
                        (route) => false,
                    );

                    } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please verify your email first.')),
                    );

                    // Redirect to the Verify Email View
                    // needs the user to be logged in to call .sendEmailVerification()
                    if (!mounted) return;
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/verify-email/',
                        (route) => false,
                    );
                    }

                } catch (e) {
                    String errorMessage = 'An error occurred';

                    // Note: still catching generic exceptions
                    // ToDo : refine this by mapping AuthService specific exceptions later back.


                    // Show a snackbar to the user
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(errorMessage)),
                    );
                  }
                },
              child: const Text('Login'),
            ),

            // Navigation
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/register/',
                  (route) => false,
                );
              },
              child: const Text('Not registered yet? Register here!'),
            ),
          ],
        ),
      ),
    );
  }
}
