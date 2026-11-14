import 'package:flutter/material.dart';

import '../core/auth_service.dart';
import '../widgets/empty_state.dart';
import 'contacts_screen.dart';
import 'welcome_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String route = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  static const List<Widget> _pages = [
    EmptyState(
      icon: Icons.chat_bubble_outline,
      title: 'No chats yet',
      message: 'Messaging is coming in Milestone 3.',
    ),
    EmptyState(
      icon: Icons.donut_large,
      title: 'No status updates yet',
      message: 'Status is coming in Milestone 5.',
    ),
    EmptyState(
      icon: Icons.call_outlined,
      title: 'No calls yet',
      message: 'Voice and video calling is coming in Milestone 6.',
    ),
    _ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HamWhatsApp')),
      body: _pages[_index],
      floatingActionButton: _index == 0
          ? FloatingActionButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(ContactsScreen.route),
              child: const Icon(Icons.chat),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.chat), label: 'Chats'),
          NavigationDestination(icon: Icon(Icons.donut_large), label: 'Status'),
          NavigationDestination(icon: Icon(Icons.call), label: 'Calls'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder<String?>(
      future: authService.myName().catchError((_) => null),
      builder: (context, snap) {
        final name = snap.data ?? '';
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                child: Text(
                  name.isEmpty ? '?' : name[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(name, style: theme.textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(authService.phone),
              const SizedBox(height: 28),
              OutlinedButton.icon(
                onPressed: () async {
                  final nav = Navigator.of(context);
                  await authService.signOut();
                  nav.pushNamedAndRemoveUntil(
                      WelcomeScreen.route, (route) => false);
                },
                icon: const Icon(Icons.logout),
                label: const Text('Log out'),
              ),
            ],
          ),
        );
      },
    );
  }
}
