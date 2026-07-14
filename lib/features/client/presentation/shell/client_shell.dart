import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClientShell extends StatelessWidget {
  const ClientShell({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.mail_outline), label: 'Inbox'),
          NavigationDestination(icon: Icon(Icons.card_travel_outlined), label: 'Trips'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
      ]),
    );
  }
}