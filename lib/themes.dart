import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

var appTheme = ThemeData(
  fontFamily: GoogleFonts.nunito().fontFamily,

  // brightness: Brightness.dark,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontSize: 18),
    bodySmall: TextStyle(fontSize: 16),
    labelLarge: TextStyle(
      letterSpacing: 1.5,
      fontWeight: FontWeight.bold,
    ),    
    displayLarge: TextStyle(
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      color: Colors.grey,
    ),
  ),
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(1, 0, 0, 255)),
  buttonTheme: const ButtonThemeData(),
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Colors.black87
  ), 
);