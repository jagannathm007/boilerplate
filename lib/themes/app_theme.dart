import 'package:boilerplate/themes/app_color.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        color: AppColors.darkSecondaryColor,
        fontFamily: "Roboto",
        fontWeight: FontWeight.bold,
        fontSize: 26,
      ),
      color: AppColors.lightPrimaryVariantColor,
      iconTheme: IconThemeData(
        color: AppColors.lightOnPrimaryColor,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimaryColor,
      secondary: AppColors.lightSecondaryColor,
      onPrimary: AppColors.lightOnPrimaryColor,
    ),
    iconTheme: IconThemeData(
      color: AppColors.iconColor,
    ),
    textTheme: _lightTextTheme,
    dividerTheme: const DividerThemeData(
      color: Colors.black12,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.darkPrimaryVariantColor,
    appBarTheme: const AppBarTheme(
      color: AppColors.darkPrimaryVariantColor,
      iconTheme: IconThemeData(
        color: AppColors.darkOnPrimaryColor,
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimaryColor,
      secondary: AppColors.darkSecondaryColor,
      onPrimary: AppColors.darkOnPrimaryColor,
      background: Colors.white12,
    ),
    iconTheme: IconThemeData(
      color: AppColors.iconColor,
    ),
    textTheme: _darkTextTheme,
    dividerTheme: const DividerThemeData(
      color: Colors.black,
    ),
  );

  static const TextTheme _lightTextTheme = TextTheme(
    headline1: _lightScreenHeading1TextStyle,
  );

  static final TextTheme _darkTextTheme = TextTheme(
    headline1: _darkScreenHeading1TextStyle,
  );

  static const TextStyle _lightScreenHeading1TextStyle = TextStyle(
    fontSize: 26.0,
    fontWeight: FontWeight.bold,
    color: AppColors.lightOnPrimaryColor,
    fontFamily: "Roboto",
  );

  static final TextStyle _darkScreenHeading1TextStyle =
      _lightScreenHeading1TextStyle.copyWith(
    color: AppColors.darkOnPrimaryColor,
  );
}
