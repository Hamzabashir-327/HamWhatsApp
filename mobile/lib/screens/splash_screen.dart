import 'package:flutter/material.dart';

import '../core/auth_service.dart';
import '../core/theme.dart';
import 'home_screen.dart';
import 'profile_setup_screen.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String route = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _route();
  }

  Future<void> _route() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    var next = WelcomeScreen.route;
    if (authService.isSignedIn) {
      try {
        next = await authService.myName() != null
            ? HomeScreen.route
            : ProfileSetupScreen.route;
      } catch (_) {
        next = HomeScreen.route; // offline: still open the app
      }
    }
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(next);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/branding/hamwhatsapp-icon.png', width: 140),
            const SizedBox(height: 24),
            const Text(
              'HamWhatsApp',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
