import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/screens/home.dart';

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
  primaryColor: const Color.fromARGB(255, 255, 255, 255),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: const Color.fromARGB(255, 255, 255, 255),
    secondary: const Color.fromARGB(255, 0, 0, 0),
  ),
  fontFamily: 'Verdana',
  buttonTheme: const ButtonThemeData(
    buttonColor: Color.fromARGB(255, 255, 255, 255),
    textTheme: ButtonTextTheme.primary,
  ),
  
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Assist Vission",
      home: HomeScreen(),
      theme: appTheme,
    );
  }
}
