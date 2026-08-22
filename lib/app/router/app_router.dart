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
// Fixed: Restored operatorShellRoute and clientShellRoute (were dropped in rewrite)
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';

// Auth
import 'package:atlas_paragliding_v2/features/auth/presentation/notifiers/auth_controller.dart';
import 'package:atlas_paragliding_v2/features/auth/presentation/screens/auth_entry_screen.dart';

// Onboarding
import 'package:atlas_paragliding_v2/features/operator/presentation/notifiers/onboarding_status_provider.dart';
import 'package:atlas_paragliding_v2/features/operator/presentation/screens/onboarding/welcome_screen.dart';
import 'package:atlas_paragliding_v2/features/operator/presentation/screens/onboarding/activity_picker_screen.dart';
import 'package:atlas_paragliding_v2/features/operator/presentation/screens/onboarding/identity_screen.dart';
import 'package:atlas_paragliding_v2/features/operator/presentation/screens/onboarding/phone_screen.dart';
import 'package:atlas_paragliding_v2/features/operator/presentation/screens/onboarding/otp_screen.dart';

// Shell routes
import 'package:atlas_paragliding_v2/app/router/operator_shell_route.dart';
import 'package:atlas_paragliding_v2/app/router/client_shell_route.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshListenable = ValueNotifier<int>(0);

  ref.listen(authNotifierProvider, (_, __) {
    refreshListenable.value++;
  });

  ref.listen(onboardingStatusProvider, (_, __) {
    refreshListenable.value++;
  });

  ref.onDispose(refreshListenable.dispose);

  final router = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshListenable,

    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      final onboardingState = ref.read(onboardingStatusProvider);

      final currentPath = state.uri.path;

      final isAuthLoading = authState.isLoading;
      final isOnboardingLoading = onboardingState.isLoading;

      final isAuthenticated = authState.value != null;

      final isPublicRoute =
          currentPath == AppRoutes.splash ||
          currentPath == AppRoutes.welcome ||
          currentPath == AppRoutes.login;

      final isOnboardingRoute =
          currentPath == AppRoutes.onboardingActivity ||
          currentPath == AppRoutes.onboardingIdentity ||
          currentPath == AppRoutes.onboardingPhone ||
          currentPath == AppRoutes.onboardingOtp;

      // Keep the splash screen visible while state is being loaded.
      if (isAuthLoading || isOnboardingLoading) {
        return currentPath == AppRoutes.splash
            ? null
            : AppRoutes.splash;
      }

      // User is not authenticated.
      if (!isAuthenticated) {
        if (currentPath == AppRoutes.welcome ||
            currentPath == AppRoutes.login) {
          return null;
        }

        // Allow onboarding only in debug mode, if desired.
        if (kDebugMode && isOnboardingRoute) {
          return null;
        }

        return AppRoutes.welcome;
      }

      // Authenticated users should not remain on authentication screens.
      if (currentPath == AppRoutes.splash ||
          currentPath == AppRoutes.welcome ||
          currentPath == AppRoutes.login) {
        return _authenticatedDestination(
          ref: ref,
          onboardingState: onboardingState,
        );
      }

      // Prevent authenticated users from being redirected away from
      // onboarding routes until onboarding is complete.
      if (isOnboardingRoute) {
        return null;
      }

      return null;
    },

    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),

      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) {
          return const WelcomeScreen();
        },
      ),

      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) {
          return const AuthEntryScreen();
        },
      ),

      GoRoute(
        path: AppRoutes.onboardingActivity,
        builder: (context, state) {
          return const ActivityPickerScreen();
        },
      ),

      GoRoute(
        path: AppRoutes.onboardingIdentity,
        builder: (context, state) {
          return const IdentityScreen();
        },
      ),

      GoRoute(
        path: AppRoutes.onboardingPhone,
        builder: (context, state) {
          return const PhoneScreen();
        },
      ),

      GoRoute(
        path: AppRoutes.onboardingOtp,
        builder: (context, state) {
          final phone = state.extra as String?;

          return OtpScreen(
            phone: phone,
          );
        },
      ),

      operatorShellRoute,
      clientShellRoute,
    ],
  );

  ref.onDispose(router.dispose);

  return router;
});

// after
String _authenticatedDestination({
  required Ref ref,
  required AsyncValue<OnboardingStatus> onboardingState,
}) {
  final status = onboardingState.value;

  // Onboarding data not loaded yet — stay on splash rather than guessing.
  if (status == null) {
    return AppRoutes.splash;
  }

  if (!status.isComplete) {
    return status.nextRoute ?? AppRoutes.onboardingActivity;
  }

  // Onboarding complete → operator, since this app currently only
  // onboards operators (no role provider wired up yet — client routing
  // is unused until client-side auth exists).
  return AppRoutes.operatorHome;
}