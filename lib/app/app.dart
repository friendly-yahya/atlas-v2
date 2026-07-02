import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atlas_paragliding_v2/app/router/app_router.dart';
import 'package:atlas_paragliding_v2/core/theme/app_theme.dart';
import 'package:atlas_paragliding_v2/core/theme/theme_provider.dart';
//temp
class AtlasApp extends ConsumerWidget {
  const AtlasApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final currentThemeMode = ref.watch(themeModeProvider);
//temp
    return MaterialApp.router(
      title: 'Atlas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.clientTheme(),
      darkTheme: AppTheme.operatorTheme(),
//temp      themeMode: ThemeMode.light,
      themeMode: currentThemeMode,
      routerConfig: router,
    );
  }
}