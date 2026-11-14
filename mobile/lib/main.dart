import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'screens/home_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/phone_screen.dart';
import 'screens/profile_setup_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const HamWhatsAppApp());
}

class HamWhatsAppApp extends StatelessWidget {
  const HamWhatsAppApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HamWhatsApp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      initialRoute: SplashScreen.route,
      routes: {
        SplashScreen.route: (_) => const SplashScreen(),
        WelcomeScreen.route: (_) => const WelcomeScreen(),
        PhoneScreen.route: (_) => const PhoneScreen(),
        OtpScreen.route: (_) => const OtpScreen(),
        ProfileSetupScreen.route: (_) => const ProfileSetupScreen(),
        HomeScreen.route: (_) => const HomeScreen(),
      },
    );
  }
}
