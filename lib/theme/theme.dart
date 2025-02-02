import 'package:flutter/material.dart';

const COLOR_PRIMARY = Colors.indigo;
const COLOR_ACCENT = Colors.indigoAccent;


const textTheme = TextTheme(
  // Titles
  titleLarge: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: Colors.black54,
  ),
  titleMedium: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.black54,
  ),
  titleSmall: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: Colors.black54,
  ),

  // Headlines
  headlineLarge: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: COLOR_PRIMARY,
  ),
  headlineMedium: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: COLOR_PRIMARY,
  ),
  headlineSmall: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: COLOR_PRIMARY,
  ),

  // Bodies
  bodyLarge: TextStyle(
    fontSize: 15,
    color: Colors.black87,
  ),
  bodyMedium: TextStyle(
    fontSize: 14,
    color: Colors.black87,
  ),
  bodySmall: TextStyle(
    fontSize: 12,
    color: Colors.black87,
  ),

  // Labels
  labelLarge: TextStyle(
    fontSize: 12,
    color: Colors.black87,
  ),
  labelMedium: TextStyle(
    fontSize: 11,
    color: Colors.black87,
  ),
  labelSmall: TextStyle(
    fontSize: 9,
    color: Colors.black87,
  ),

  // Table elements
);

var mainTheme = ThemeData(
  // Use latest material
  useMaterial3: true,

  // Default colors
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: COLOR_PRIMARY,
  ),

  textTheme: textTheme,
  // textTheme: Theme.of(context).textTheme.apply(
  //   fontSizeFactor: 0.8,
  //   fontSizeDelta: 0.9,
  // ),
);
