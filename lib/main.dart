import 'package:flutter/material.dart';
import 'package:pocket_finances/constants.dart';
import 'package:pocket_finances/screens/main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        textSelectionTheme:
            TextSelectionThemeData(cursorColor: kSelectionColor),
        brightness: Brightness.dark,
        primaryColor: Color(0xFF181F2C),
        scaffoldBackgroundColor: Color(0xFF181F2C),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        indicatorColor: kSelectionColor,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF475BBF),
          foregroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: Color(0x70475BBF),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: kSelectionColor),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              style: BorderStyle.solid,
              color: kSelectionColor,
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
      },
    );
  }
}
