//register_view.dart

import 'package:flutter/material.dart';
import 'login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
                final userCredential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                );

                print('Successfully registered: ${userCredential.user?.email}');

                // ToDO later: Navigate to Login
                // Navigator.of(context).pushNamedAndRemoveUntil('/login/', (route) => false);

                } on FirebaseAuthException catch (e) {
                // Handle specific Firebase errors
                if (e.code == 'weak-password') {
                    print('The password provided is too weak.');
                } else if (e.code == 'email-already-in-use') {
                    print('The account already exists for that email.');
                } else if (e.code == 'invalid-email') {
                    print('The email address is badly formatted.');
                }
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
                Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginView()),
                (route) => false
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
