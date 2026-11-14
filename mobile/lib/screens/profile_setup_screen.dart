import 'package:flutter/material.dart';

import '../core/theme.dart';
import 'home_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  static const String route = '/profile-setup';

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _valid => _controller.text.trim().length >= 2;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = _controller.text.trim();
    return Scaffold(
      appBar: AppBar(title: const Text('Profile info')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                'Please enter your name. This is what your contacts will see.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: 28),
              CircleAvatar(
                radius: 52,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                child: name.isEmpty
                    ? Icon(Icons.person,
                        size: 56, color: theme.colorScheme.primary)
                    : Text(
                        name[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
              ),
              const SizedBox(height: 28),
              TextField(
                controller: _controller,
                autofocus: true,
                maxLength: 25,
                textCapitalization: TextCapitalization.words,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  labelText: 'Your name',
                  prefixIcon: Icon(Icons.badge_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 200,
                child: FilledButton(
                  onPressed: _valid
                      ? () => Navigator.of(context).pushNamedAndRemoveUntil(
                            HomeScreen.route,
                            (route) => false,
                          )
                      : null,
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
