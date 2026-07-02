import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Create a strictly typed Notifier class
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    // This is the initial state (Client Mode)
    return ThemeMode.light; 
  }

  // 2. Expose a method to change the state
  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

// 3. Create the Provider using the modern NotifierProvider syntax
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(() {
  return ThemeModeNotifier();
});