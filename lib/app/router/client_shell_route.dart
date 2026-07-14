import 'package:go_router/go_router.dart';
import '../../features/client/presentation/shell/client_shell.dart';
import '../../features/client/presentation/screens/home_screen.dart';
import '../../features/client/presentation/screens/inbox_screen.dart';
import '../../features/client/presentation/screens/trips_screen.dart';
import '../../features/client/presentation/screens/profile_screen.dart';

final clientShellRoute = StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) => ClientShell(navigationShell: navigationShell),
  branches: [
    StatefulShellBranch(routes: [
      GoRoute(path: '/client/home', builder: (context, state) => const HomeScreen())]),
    
    StatefulShellBranch(routes: [
      GoRoute(path: '/client/inbox', builder: (context, state) => const InboxScreen())]),
    
    StatefulShellBranch(routes: [
      GoRoute(path: '/client/trips', builder: (context, state) => const TripsScreen())]),
    
    StatefulShellBranch(routes: [
      GoRoute(path: '/client/profile', builder: (context, state) => const ProfileScreen())]),
    
  ]
);