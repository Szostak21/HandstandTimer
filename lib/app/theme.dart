import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const _electricBlue = Color(0xFF2979FF);

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _electricBlue,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF0D1117),
    cardTheme: CardThemeData(
      elevation: 0,
      color: const Color(0xFF161B22),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF0D1117),
      indicatorColor: _electricBlue.withAlpha(40),
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0D1117),
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
    ),
  );
}
