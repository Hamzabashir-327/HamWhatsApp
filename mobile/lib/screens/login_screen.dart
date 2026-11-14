import 'package:flutter/material.dart';

import '../widgets/phone_auth_form.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const String route = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
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
                  const Text('Apna phone number likhein'),
                  const SizedBox(height: 24),
                  const PhoneAuthForm(isRegister: false),
                  TextButton(
                    onPressed: () => Navigator.of(context)
                        .pushReplacementNamed(RegisterScreen.route),
                    child: const Text('Naya account banayein'),
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
