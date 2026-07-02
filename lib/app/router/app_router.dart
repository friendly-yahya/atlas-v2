import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:atlas_paragliding_v2/app/router/app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const Scaffold(
          body: Center(child: CircularProgressIndicator(),),
        )),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Login screen *placeholder'),),
        )),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Client home *placeholder'),),
        )),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Operator home *placeholder'),),
        )),
    ]);
});