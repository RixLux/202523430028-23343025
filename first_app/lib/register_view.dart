//register_view.dart

import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'login_view.dart';
import 'verify_email_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  // Variables
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
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input Fields
            TextField(
              controller: _email,
              decoration: const InputDecoration(hintText: 'Enter email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _password,
              decoration: const InputDecoration(hintText: 'Enter password'),
              obscureText: true, // Hides password dots
            ),

            // Action Button
            TextButton(
            onPressed: () async {
                final email = _email.text;
                final password = _password.text;

                try {
                await AuthService().createUser(
                    email: email,
                    password: password,
                );

                await AuthService().sendEmailVerification();

                if (!mounted) return;
                // Navigate to Verification view
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/verify-email/',
                    (route) => false,
                );

                } on WeakPasswordAuthException {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Weak password.')),
                  );
                } on EmailAlreadyInUseAuthException {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Email already in use.')),
                  );
                } on InvalidEmailAuthException {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid email.')),
                  );
                } on GenericAuthException {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registration error.')),
                  );
                } catch (e) {
                // Handle any other unexpected errors
                print('Something went wrong: $e');
                }
            },
            child: const Text('Register'),
            ),


            TextButton(
            onPressed: () {
                // This navigates to the Register screen
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login/',
                  (route) => false,
                );
            },
            child: const Text('Already have an account? Login here!'),
            ),
          ],
        ),
      ),
    );
  }
}
