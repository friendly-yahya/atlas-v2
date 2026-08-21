/* 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:atlas_paragliding_v2/app/router/app_routes.dart';
import 'package:atlas_paragliding_v2/features/playground/theme_showcase_screen.dart';
import 'package:atlas_paragliding_v2/features/auth/presentation/notifiers/auth_controller.dart';
import 'package:atlas_paragliding_v2/app/router/client_shell_route.dart';
import 'package:atlas_paragliding_v2/app/router/operator_shell_route.dart';
import 'package:atlas_paragliding_v2/features/auth/presentation/notifiers/role_controller.dart';
import 'package:atlas_paragliding_v2/features/auth/presentation/screens/auth_entry_screen.dart';
import 'package:atlas_paragliding_v2/features/operator/presentation/screens/onboarding/activity_picker_screen.dart';
import 'package:atlas_paragliding_v2/features/operator/presentation/screens/onboarding/welcome_screen.dart';
import 'package:atlas_paragliding_v2/features/operator/presentation/screens/onboarding/identity_screen.dart';
import 'package:atlas_paragliding_v2/features/operator/presentation/screens/onboarding/phone_screen.dart';
import 'package:atlas_paragliding_v2/features/operator/presentation/screens/onboarding/otp_screen.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:atlas_paragliding_v2/features/operator/presentation/screens/become_operator_screen.dart';
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
      return path == AppRoutes.login ? null : AppRoutes.login;
      }
      final roleState = ref.read(roleNotifierProvider);
      if(roleState.isLoading) return null;

      final role = roleState.value;
      final target = role == 'operator' ? AppRoutes.operatorHome : AppRoutes.clientHome;
      //if (loggedIn && onAuthScreen) return AppRoutes.clientHome;
      if (path == AppRoutes.login || path == AppRoutes.splash) return target;
    },
    routes: [
      if (kDebugMode)
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
        builder: (context, state) => const AuthEntryScreen(),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(), // placeholder you'll build later
      ),
      GoRoute(
        path: AppRoutes.onboardingActivity,
        builder: (context, state) => const ActivityPickerScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingIdentity,
        builder: (context, state) => const IdentityScreen(), // Screen 2 — build next
      ),
      GoRoute(
        path: AppRoutes.onboardingPhone,
        builder: (context, state) => const PhoneScreen(), // Screen 3 — build next
      ),
      GoRoute(
        path: AppRoutes.onboardingOtp,
        builder: (context, state) => const OtpScreen(), // Screen 4 — build next
      ),
      GoRoute(
        path: AppRoutes.becomeOperator,
        builder: (context, state) => const BecomeOperatorScreen(),
      ),
      clientShellRoute,
      operatorShellRoute,
    ]);
}); */

// COMPLETE REPLACEMENT — lib/app/router/app_router.dart
// Fixed: ValueNotifier replaces broken RouterRefresh
// Fixed: Routes extract state.extra for OTP phone number

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';

// Auth
import 'package:atlas_paragliding_v2/features/auth/presentation/notifiers/auth_controller.dart';

// Onboarding
import 'package:atlas_paragliding_v2/features/operator/presentation/notifiers/onboarding_status_provider.dart';
import 'package:atlas_paragliding_v2/features/operator/presentation/screens/onboarding/welcome_screen.dart';
import 'package:atlas_paragliding_v2/features/operator/presentation/screens/onboarding/activity_picker_screen.dart';
import 'package:atlas_paragliding_v2/features/operator/presentation/screens/onboarding/identity_screen.dart';
import 'package:atlas_paragliding_v2/features/operator/presentation/screens/onboarding/phone_screen.dart';
import 'package:atlas_paragliding_v2/features/operator/presentation/screens/onboarding/otp_screen.dart';

// Operator home
import 'package:atlas_paragliding_v2/features/operator/presentation/screens/operator_home_screen.dart';

// Client
import 'package:atlas_paragliding_v2/features/client/presentation/shell/client_shell.dart';
import 'package:atlas_paragliding_v2/features/client/presentation/screens/client_home_screen.dart';
import 'package:atlas_paragliding_v2/features/client/presentation/screens/home_screen.dart';
import 'package:atlas_paragliding_v2/features/client/presentation/screens/inbox_screen.dart';
import 'package:atlas_paragliding_v2/features/client/presentation/screens/trips_screen.dart';
import 'package:atlas_paragliding_v2/features/auth/presentation/screens/auth_entry_screen.dart';
final appRouterProvider = Provider<GoRouter>((ref) {
  // ValueNotifier that GoRouter watches. Incremented when auth/onboarding changes.
  final refreshListenable = ValueNotifier<int>(0);

  // Listen to Riverpod providers → increment → GoRouter re-evaluates redirect
  ref.listen(authNotifierProvider, (_, __) => refreshListenable.value++);
  ref.listen(onboardingStatusProvider, (_, __) => refreshListenable.value++);

  return GoRouter(
    refreshListenable: refreshListenable,
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final authAsync = ref.read(authNotifierProvider);
      final onboardingAsync = ref.read(onboardingStatusProvider);

      final isAuthenticated = authAsync.value != null;
      final currentPath = state.matchedLocation;

      final isAuthRoute = currentPath == AppRoutes.welcome ||
          currentPath == AppRoutes.login;
      final isOnboardingRoute = currentPath.startsWith('/onboarding');

      // Not logged in → welcome screen
      if (!isAuthenticated && !isAuthRoute) {
        return AppRoutes.welcome;
      }

      // Logged in → check onboarding progress
      if (isAuthenticated && onboardingAsync.hasValue) {
        final status = onboardingAsync.value!;

        // Already complete but on onboarding route → send home
        if (isOnboardingRoute && status.isComplete) {
          return AppRoutes.operatorHome;
        }

        // Incomplete and not on onboarding → send to next step
        if (!isOnboardingRoute && !status.isComplete) {
          return status.nextRoute ?? AppRoutes.operatorHome;
        }
      }

      return null; // No redirect
    },
    routes: [
      // Splash
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),

      // Auth / Welcome
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const AuthEntryScreen(),
      ),

      // Onboarding flow
      GoRoute(
        path: AppRoutes.onboardingActivity,
        builder: (context, state) => const ActivityPickerScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingIdentity,
        builder: (context, state) => const IdentityScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingPhone,
        builder: (context, state) => const PhoneScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingOtp,
        builder: (context, state) => OtpScreen(
          phone: state.extra as String?,
        ),
      ),

      // Operator home
      GoRoute(
        path: AppRoutes.operatorHome,
        builder: (context, state) => const OperatorHomeScreen(),
      ),

      // Client shell with bottom nav
      ShellRoute(
        builder: (context, state, child) => ClientShell(
          navigationShell: child as StatefulNavigationShell,
        ),
        routes: [
          GoRoute(
            path: AppRoutes.clientHome,
            builder: (context, state) => const ClientHomeScreen(),
          ),
        ],
      ),
    ],
  );
});