import 'package:go_router/go_router.dart';
import 'package:atlas_paragliding_v2/features/operator/presentation/shell/operator_shell.dart';
import 'package:atlas_paragliding_v2/features/operator/presentation/screens/dashboard_screen.dart';
import 'package:atlas_paragliding_v2/features/operator/presentation/screens/inbox_screen.dart';
import 'package:atlas_paragliding_v2/features/operator/presentation/screens/bookings_screen.dart';
import 'package:atlas_paragliding_v2/features/operator/presentation/screens/tools_screen.dart';
import 'package:atlas_paragliding_v2/features/operator/presentation/screens/profile_screen.dart';


final operatorShellRoute = StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) => OperatorShell(navigationShell: navigationShell),
  branches: [
    StatefulShellBranch(routes: [
      GoRoute(path: '/operator/home', builder: (context, state) => const DashboardScreen()),
    ]),
    StatefulShellBranch(routes: [
      GoRoute(path: '/operator/inbox', builder: (context, state) => const InboxScreen()),
    ]),
    StatefulShellBranch(routes: [
      GoRoute(path: '/operator/bookings', builder: (context, state) => const BookingsScreen()),
    ]),
    StatefulShellBranch(routes: [
      GoRoute(path: '/operator/tools', builder: (context, state) => const ToolsScreen()),
    ]),
    StatefulShellBranch(routes: [
      GoRoute(path: '/operator/profile', builder: (context, state) => const ProfileScreen()),
    ]),   
  ],
  );