import 'package:flutter/material.dart';
import 'signIn.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        backgroundColor: Color(0xFF17182C),
        accentColor: Color(0xFF40D383),
        canvasColor: Color(0xFF48494D),
        fontFamily: 'Nunito',
        textTheme: TextTheme(
      body1: TextStyle(),
      body2: TextStyle(),
    ).apply(
      bodyColor: Colors.white, 
      displayColor: Colors.white, 
    ),
      ),
      home: LoginPage(title: 'Login'),
    );
  }
}
