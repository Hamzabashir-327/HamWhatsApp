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
      title: 'Abhi koi chat nahi',
      message: 'Messaging Milestone 3 mein aayegi.',
    ),
    EmptyState(
      icon: Icons.donut_large,
      title: 'Abhi koi status nahi',
      message: 'Status system Milestone 5 mein aayega.',
    ),
    EmptyState(
      icon: Icons.call_outlined,
      title: 'Call history khali hai',
      message: 'Voice aur video calling Milestone 6 mein aayegi.',
    ),
    EmptyState(
      icon: Icons.person_outline,
      title: 'Profile',
      message: 'Profile setup Milestone 2 mein aayega.',
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
