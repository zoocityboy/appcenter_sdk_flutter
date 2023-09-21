import 'package:flutter/material.dart';

final baseDarkTheme = ThemeData.from(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xffCB2E63).withOpacity(.7),
    brightness: Brightness.dark,
  ),
  useMaterial3: true,
);
final darkTheme = baseDarkTheme.copyWith(
  appBarTheme: AppBarTheme(
    foregroundColor: baseDarkTheme.colorScheme.primaryContainer,
  ),
);

final baseLightTheme = ThemeData.from(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xffCB2E63),
  ),
  useMaterial3: true,
);
final lightTheme = baseLightTheme.copyWith(
  appBarTheme: AppBarTheme(
    foregroundColor: baseDarkTheme.colorScheme.primaryContainer,
  ),
);
