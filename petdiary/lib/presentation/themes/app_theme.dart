// ignore: file_names
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: const Color.fromARGB(255, 255, 251, 234),
    colorScheme: const ColorScheme.light(
        primary: Color.fromARGB(244, 185, 142, 80),
        secondary: Color.fromARGB(255, 253, 247, 222),
        background: Color.fromARGB(255, 255, 251, 234),
        shadow: Colors.black12,
        brightness: Brightness.light),
    scaffoldBackgroundColor: const Color.fromARGB(255, 255, 251, 234),
    iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                const Color.fromARGB(255, 255, 251, 234)))),
    buttonTheme: const ButtonThemeData(
        colorScheme: ColorScheme.light(
            background: Color.fromARGB(244, 255, 251, 234),
            secondary: Color.fromARGB(255, 253, 247, 222),
            brightness: Brightness.light,
            primary: Color.fromARGB(244, 185, 142, 80))),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          fontSize: 28.0, fontFamily: 'Montserrat_Bold', color: Colors.black),
      displayMedium: TextStyle(
          fontSize: 24.0,
          fontFamily: 'Montserrat_Regular',
          color: Colors.black),
      displaySmall: TextStyle(
          fontSize: 20.0,
          fontFamily: 'Montserrat_Regular',
          color: Colors.black),
      bodyLarge: TextStyle(
          fontSize: 20.0,
          fontFamily: 'Montserrat_Regular',
          color: Colors.black),
      bodyMedium: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          fontFamily: 'Montserrat_Regular',
          color: Colors.black),
      bodySmall: TextStyle(
          fontSize: 14.0,
          fontFamily: 'Montserrat_Regular',
          color: Colors.black),
    ),
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.green.shade100,
    scaffoldBackgroundColor: Colors.grey[900],
    colorScheme: ColorScheme.dark(
        primary: Colors.green.shade50,
        secondary: Colors.brown.shade800,
        background: Colors.grey.shade900,
        shadow: Colors.white10,
        brightness: Brightness.dark),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 28.0,
        fontFamily: 'Montserrat_Light',
        color: Colors.black,
      ),
      displayMedium: TextStyle(
        fontSize: 24.0,
        fontFamily: 'Montserrat_Light',
        color: Colors.black,
      ),
      displaySmall: TextStyle(
        fontSize: 20.0,
        fontFamily: 'Montserrat_Thin',
        color: Colors.black,
      ),
      bodyLarge: TextStyle(
        fontSize: 20.0,
        fontFamily: 'Montserrat_LightItalic',
        color: Colors.black,
      ),
      bodyMedium: TextStyle(
        fontSize: 16.0,
        fontFamily: 'Montserrat_Italic',
        color: Colors.black,
      ),
      bodySmall: TextStyle(
        fontSize: 15.0,
        fontFamily: 'Montserrat_Light',
        color: Colors.black,
      ),
    ),
  );
}

// ignore: must_be_immutable
