import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/pages/login_page.dart';
import 'package:flutter_ecommerce/pages/register_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter E-Commerce',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.cyan[400],
        accentColor: Colors.deepOrange[200],
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 72.0,
            fontWeight: FontWeight.bold,
          ),
          // subtitle1: TextStyle(
          //   fontSize: 36.0,
          //   fontStyle: FontStyle.italic,
          // ),
          // bodyText1: TextStyle(
          //   fontSize: 18.0,
          // ),
        ),
      ),
      home: RegisterPage(),
      routes: {
        // "/login": (context) => LoginPage(),
        LoginPage.id: (context) => LoginPage(),
        RegisterPage.id: (context) => RegisterPage(),
      },
    );
  }
}
