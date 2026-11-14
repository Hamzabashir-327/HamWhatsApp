import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'firebase_options.dart';
import 'screens/contacts_screen.dart';
import 'screens/home_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/phone_screen.dart';
import 'screens/profile_setup_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    runApp(_SetupErrorApp(message: '$e'));
    return;
  }
  runApp(const HamWhatsAppApp());
}

class _SetupErrorApp extends StatelessWidget {
  const _SetupErrorApp({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(message, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
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
        ContactsScreen.route: (_) => const ContactsScreen(),
      },
    );
  }
}
