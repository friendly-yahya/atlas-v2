import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class OperatorShell extends StatelessWidget {
  const OperatorShell({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.mail_outline), label: 'Inbox'),
          NavigationDestination(icon: Icon(Icons.event_note_outlined), label: 'Bookings'),
          NavigationDestination(icon: Icon(Icons.build_outlined), label: 'Tools'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}