import 'package:flutter/material.dart';
import 'package:atlas_paragliding_v2/app/router/app_routes.dart';
import 'package:go_router/go_router.dart';
class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('Client home')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(AppRoutes.operatorHome),
        label: const Text('DEV: Preview operator view'),
      ),
    );
  }
}