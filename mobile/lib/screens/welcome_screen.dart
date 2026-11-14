import 'package:flutter/material.dart';

import '../core/theme.dart';
import 'phone_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const String route = '/welcome';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
          child: Column(
            children: [
              const Spacer(),
              Image.asset('assets/branding/hamwhatsapp-icon.png', height: 150),
              const SizedBox(height: 28),
              Text(
                'Welcome to HamWhatsApp',
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Connect. Chat. Share.',
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: AppColors.textMuted),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              FilledButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(PhoneScreen.route),
                child: const Text('Agree and continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
