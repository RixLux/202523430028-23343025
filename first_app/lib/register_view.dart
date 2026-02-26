import 'package:flutter/material.dart';
import 'login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  // 1. Variables
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
            // 2. Input Fields
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

            // 3. The Action Button
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                // Todo later: plug in Firebase
                print('Registering with $email');
              },
              child: const Text('Register'),
            ),


            TextButton(
            onPressed: () {
                // This navigates to the Register screen
                Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LoginView()),
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
