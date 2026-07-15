
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:atlas_paragliding_v2/app/router/app_routes.dart';
import 'package:atlas_paragliding_v2/features/auth/presentation/screens/register_screen.dart';
import 'package:atlas_paragliding_v2/features/playground/theme_showcase_screen.dart';
import 'package:atlas_paragliding_v2/features/auth/presentation/notifiers/auth_controller.dart';
import 'package:atlas_paragliding_v2/features/auth/presentation/screens/login_screen.dart';
import 'package:atlas_paragliding_v2/app/router/client_shell_route.dart';
import 'package:atlas_paragliding_v2/app/router/operator_shell_route.dart';
import 'package:atlas_paragliding_v2/features/auth/presentation/notifiers/role_controller.dart';
class _RouterRefreshNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}


final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _RouterRefreshNotifier();
  ref.listen(authNotifierProvider, (_, __) => refreshNotifier.refresh());
  ref.listen(roleNotifierProvider, (_, __) => refreshNotifier.refresh());
  ref.onDispose(refreshNotifier.dispose);
  //final authStream = ref.watch(authRepositoryProvider).authStateChanges;
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshNotifier,
    //initialLocation: AppRoutes.showcase,
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      if (authState.isLoading) return null;
      final loggedIn = authState.value != null;
      final path = state.uri.path;
      //final onAuthScreen = state.uri.path == AppRoutes.login || state.uri.path == AppRoutes.splash;
      if (!loggedIn) {
        final onAuthScreen = path == AppRoutes.login || path == AppRoutes.register;
        return onAuthScreen ? null : AppRoutes.login;
      }
      final roleState = ref.read(roleNotifierProvider);
      if(roleState.isLoading) return null;

      final role = roleState.value;
      final target = role == 'operator' ? AppRoutes.operatorHome : AppRoutes.clientHome;
      //if (loggedIn && onAuthScreen) return AppRoutes.clientHome;
      if (path == AppRoutes.login || path == AppRoutes.splash || path == AppRoutes.register){return target;}
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
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      clientShellRoute,
      operatorShellRoute,
    ]);
});