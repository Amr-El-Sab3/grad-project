import 'package:flutter/material.dart';

// Light Theme
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    surface: Color(0xFFDEF9C4),
    primary: Color(0xFF9CDBA6),
    secondary: Color(0xFF50B498),
    tertiary: Color(0xFF468585),
  ),
  scaffoldBackgroundColor: const Color(0xFFDEF9C4),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Colors.white,
    endShape: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.zero),
    ),
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.transparent,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    // Customize text styles if needed
    titleLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Color(0xFF468585)),
  ),
);




// Dark Theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFFA2B3B0),
    primary: Color(0xFF7CD7C2),
    secondary: Color(0xFF7CD7C2),
    tertiary: Color(0xFF121D41),
  ),
  scaffoldBackgroundColor: const Color(0xFFA2B3B0),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color(0xFF1E1E1E),
    endShape: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.zero),
    ),
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.transparent,
    elevation: 0,
  ),
  textTheme: TextTheme(
    // Adjust text colors for better contrast in dark mode
    titleLarge: const TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.grey[400]),
  ),
);