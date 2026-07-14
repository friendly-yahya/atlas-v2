// features/client/presentation/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:atlas_paragliding_v2/app/router/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Profile'),
            TextButton(
              onPressed: () => context.go(AppRoutes.clientHome),
              child: const Text('DEV: switch to client'),
            ),
          ],
        ),
      ),
    );
  }
}