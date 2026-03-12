// verify_email_view.dart

import 'dart:async'; // for timer :)
import 'package:flutter/material.dart';
import 'auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  Timer? _timer;
  bool isVerified = false; // 1. Track the verification status

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      checkEmailVerified();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    await AuthService().reloadUser();
    final user = AuthService().currentUser;

    if (user?.isEmailVerified ?? false) {
      _timer?.cancel();

      // 2. Update the state to show success UI
      setState(() {
        isVerified = true;
      });

      // 3. Add a small delay so they can actually read the success message
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/notes/',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 4. Use a Ternary operator to switch the UI
            if (isVerified) ...[
              const Icon(Icons.check_circle, color: Colors.green, size: 60),
              const SizedBox(height: 20),
              const Text(
                'Email Verified!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text('Redirecting you to your notes...'),
            ] else ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Verification email sent! Please check your inbox. We'll move you forward automatically once verified.",
                  textAlign: TextAlign.center,
                ),
              ),
              TextButton(
                onPressed: () async {
                  await AuthService().sendEmailVerification();
                },
                child: const Text('Resend Email'),
              ),
              TextButton(
                onPressed: () async {
                  _timer?.cancel();
                  await AuthService().logOut();
                  if (!mounted) return;
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/register/',
                    (route) => false,
                  );
                },
                child: const Text('Back to Register Page'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
