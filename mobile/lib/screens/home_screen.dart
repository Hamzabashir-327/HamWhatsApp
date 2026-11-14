import 'package:flutter/material.dart';

import '../widgets/empty_state.dart';

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
    EmptyState(
      icon: Icons.person_outline,
      title: 'Profile',
      message: 'Profile settings are coming in Milestone 2.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HamWhatsApp')),
      body: _pages[_index],
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
