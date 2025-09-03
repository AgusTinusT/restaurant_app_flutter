import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app/style/app_colors.dart';
import 'package:restaurant_app/style/app_text_style.dart';

final poppinsTextTheme = GoogleFonts.poppinsTextTheme(restaurantTextTheme);

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: RestaurantColors.primary,
    secondary: RestaurantColors.secondary,
    surface: RestaurantColors.surface,
    onPrimary: RestaurantColors.onPrimary,
    onSecondary: RestaurantColors.onSecondary,
    onSurface: RestaurantColors.onBackground,
    error: Colors.redAccent,
    onError: Colors.white,
  ),
  textTheme: poppinsTextTheme.apply(
    bodyColor: RestaurantColors.onBackground,
    displayColor: RestaurantColors.onBackground,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: RestaurantColors.background,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: poppinsTextTheme.headlineSmall?.copyWith(
      color: RestaurantColors.darkBackground,
    ),
    iconTheme: IconThemeData(color: RestaurantColors.darkBackground),
  ),
  iconTheme: IconThemeData(color: RestaurantColors.secondary),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: RestaurantColors.primary,
    unselectedItemColor: Colors.grey,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: RestaurantColors.primary,
      foregroundColor: RestaurantColors.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    suffixIconColor: RestaurantColors.darkPrimary,
    prefixIconColor: RestaurantColors.darkPrimary,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(24.0),
      borderSide: BorderSide(color: RestaurantColors.primary),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(24.0),
      borderSide: BorderSide(color: RestaurantColors.primary, width: 2.0),
    ),
    labelStyle: TextStyle(color: RestaurantColors.onBackground),
    hintStyle: TextStyle(color: Colors.grey[600]),
  ),
);

ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: RestaurantColors.darkPrimary,
    secondary: RestaurantColors.darkSecondary,
    surface: RestaurantColors.darkSurface,
    onPrimary: RestaurantColors.darkOnPrimary,
    onSecondary: RestaurantColors.darkOnSecondary,
    onSurface: RestaurantColors.darkOnBackground,
    error: Colors.red,
    onError: Colors.black,
  ),
  textTheme: poppinsTextTheme.apply(
    bodyColor: RestaurantColors.darkOnBackground,
    displayColor: RestaurantColors.darkOnBackground,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: RestaurantColors.darkSurface,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: poppinsTextTheme.headlineSmall?.copyWith(
      color: RestaurantColors.darkOnBackground,
    ),
    iconTheme: IconThemeData(color: RestaurantColors.darkOnBackground),
  ),
  iconTheme: IconThemeData(color: RestaurantColors.darkSecondary),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: RestaurantColors.darkPrimary,
    unselectedItemColor: Colors.grey[400],
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: RestaurantColors.primary,
      foregroundColor: RestaurantColors.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    suffixIconColor: RestaurantColors.darkPrimary,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(24.0),
      borderSide: BorderSide(color: RestaurantColors.darkPrimary),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(24.0),
      borderSide: BorderSide(color: RestaurantColors.darkPrimary, width: 2.0),
    ),
    labelStyle: TextStyle(color: RestaurantColors.darkOnBackground),
    hintStyle: TextStyle(color: Colors.grey[400]),
  ),
);
