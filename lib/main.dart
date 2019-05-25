import 'package:flutter/material.dart';
import 'Login.dart';
import 'Register.dart';
import 'Home.dart';
import 'Profile.dart';
import 'Friend.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.pink[200]
      ),
     initialRoute: "/",
     routes: {
       "/": (context) => Login(),
       "/register": (context) => Register(),
       "/home": (context) => Home(),
       "/profile": (context) => Profile(),
       "/friend": (context) => Friend()
     },
    );
  }
}

