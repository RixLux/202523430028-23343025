//login_view.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_view.dart';

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

            // Updated Login Button with Firebase
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;

                try {
                  final userCredential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  if (!mounted) return;

                  // succesful login :)
                  Navigator.of(context).pushNamedAndRemoveUntil('/notes/', (route) => false);

                } on FirebaseAuthException catch (e) {
                    String errorMessage = 'An error occurred';


                    if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
                      errorMessage = 'Invalid login credentials.';
                    } else if (e.code == 'wrong-password') {
                      errorMessage = 'Wrong password provided.';
                    } else if (e.code == 'channel-error') {
                      errorMessage = 'Please fill in all fields.';
                    }

                    // Show a snackbar to the user
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(errorMessage)),
                    );
                  } catch (e) {
                    print(e); // For debugging
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
