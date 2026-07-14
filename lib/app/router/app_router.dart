import 'package:atlas_paragliding_v2/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:atlas_paragliding_v2/app/router/router_refresh_stream.dart';
import 'package:atlas_paragliding_v2/app/router/app_routes.dart';
import 'package:atlas_paragliding_v2/features/playground/theme_showcase_screen.dart';
import 'package:atlas_paragliding_v2/features/auth/presentation/notifiers/auth_controller.dart';
import 'package:atlas_paragliding_v2/features/operator/presentation/screens/operator_home_screen.dart';
import 'package:atlas_paragliding_v2/features/auth/presentation/screens/login_screen.dart';
import 'package:atlas_paragliding_v2/app/router/client_shell_route.dart';
import 'package:atlas_paragliding_v2/app/router/operator_shell_route.dart';
final appRouterProvider = Provider<GoRouter>((ref) {
  final authStream = ref.watch(authRepositoryProvider).authStateChanges;
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: GoRouterRefreshStream(authStream),
    //initialLocation: AppRoutes.showcase,
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      if (authState.isLoading) return null;
      final loggedIn = authState.value != null;
      final path = state.uri.path;
      //final onAuthScreen = state.uri.path == AppRoutes.login || state.uri.path == AppRoutes.splash;
      if (!loggedIn) {
        return path == AppRoutes.login ? null : AppRoutes.login;
        }
      //if (loggedIn && onAuthScreen) return AppRoutes.clientHome;
      if (path == AppRoutes.login || path == AppRoutes.splash){return AppRoutes.clientHome;}
      return null;
    },
    routes: [
//temp
      GoRoute(
        path: '/showcase',
        builder: (context, state) => const ThemeShowcaseScreen(),
      ),
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const Scaffold(
          body: Center(child: CircularProgressIndicator(),),
        )),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      clientShellRoute,
      operatorShellRoute,
    ]);
});