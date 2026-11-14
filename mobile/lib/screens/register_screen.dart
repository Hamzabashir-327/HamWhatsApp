import 'package:flutter/material.dart';

import '../widgets/phone_auth_form.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  static const String route = '/register';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/branding/hamwhatsapp-icon.png',
                      height: 80),
                  const SizedBox(height: 16),
                  const Text('Naam aur phone number likhein'),
                  const SizedBox(height: 24),
                  const PhoneAuthForm(isRegister: true),
                  TextButton(
                    onPressed: () => Navigator.of(context)
                        .pushReplacementNamed(LoginScreen.route),
                    child: const Text('Pehle se account hai? Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
