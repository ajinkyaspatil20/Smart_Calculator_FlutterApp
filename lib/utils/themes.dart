import 'package:flutter/material.dart';

class AppTheme {
  static const Color darkPrimaryColor = Color(0xFF252525);
  static const Color darkSecondaryColor = Color(0xFF1E1E1E);
  static const Color darkAccentColor = Colors.deepPurple;
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkSurfaceColor = Color(0xFF1E1E1E);
  static const Color darkErrorColor = Colors.red;
  static const Color darkSuccessColor = Colors.green;

  static const Color lightPrimaryColor = Colors.blue;
  static const Color lightSecondaryColor = Colors.white;
  static const Color lightAccentColor = Colors.deepPurple;
  static const Color lightBackgroundColor = Colors.white;
  static final Color? lightSurfaceColor = Colors.grey[50];
  static const Color lightErrorColor = Colors.red;
  static const Color lightSuccessColor = Color(0xFF4CAF50);

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkPrimaryColor,
    primaryColor: darkAccentColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkAccentColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: darkAccentColor,
      secondary: darkSecondaryColor,
      surface: darkSurfaceColor,
      background: darkBackgroundColor,
      error: darkErrorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: darkPrimaryColor,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
    listTileTheme: ListTileThemeData(
      tileColor: darkSecondaryColor,
      iconColor: Colors.white,
      textColor: Colors.white,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
      labelLarge: TextStyle(color: Colors.white70),
    ),
    iconTheme: IconThemeData(color: Colors.white),
    cardTheme: CardTheme(
      color: darkSecondaryColor,
      elevation: 2,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: darkSecondaryColor,
      filled: true,
      labelStyle: TextStyle(color: Colors.white70),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: darkAccentColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: darkAccentColor.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: darkAccentColor),
      ),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: TextStyle(color: Colors.white),
      menuStyle: MenuStyle(
        backgroundColor: MaterialStatePropertyAll(darkSecondaryColor),
      ),
    ),
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightSecondaryColor,
    primaryColor: lightPrimaryColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightPrimaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: lightPrimaryColor,
      secondary: lightSecondaryColor,
      surface: lightSurfaceColor ?? Colors.grey[50]!,
      background: lightBackgroundColor,
      error: lightErrorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.black87,
      onSurface: Colors.black87,
      onBackground: Colors.black87,
      onError: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: lightPrimaryColor,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
    listTileTheme: ListTileThemeData(
      tileColor: Colors.grey[100],
      iconColor: Colors.black87,
      textColor: Colors.black87,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
      titleMedium: TextStyle(color: Colors.black87),
      labelLarge: TextStyle(color: Colors.black54),
    ),
    iconTheme: IconThemeData(color: Colors.black87),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.grey[50],
      filled: true,
      labelStyle: TextStyle(color: Colors.black54),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: lightAccentColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: lightAccentColor.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: lightAccentColor),
      ),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: TextStyle(color: Colors.black87),
      menuStyle: MenuStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.white),
      ),
    ),
  );
}
