import 'package:flutter/material.dart';
import 'package:atlas_paragliding_v2/features/operator/presentation/screens/complete_profile_screen.dart';
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FilledButton(onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const CompleteProfileScreen()),
        ), 
        child: const Text('Complete your profile'),
        )
      )
    );
  }
}