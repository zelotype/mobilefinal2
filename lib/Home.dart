import 'package:flutter/material.dart';
import 'SharedPreferences.dart';
import 'RWfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeState();
  }

}

class HomeState extends State<Home> {

  String name = "Name";
  String quote = "something";
  @override
  Widget build(BuildContext context) {
    Future<String> file = FileManager.fileManager.readFile();
    file.then(
      (value) {
        setState(() {
          if(value.isNotEmpty){
            quote = value;
          }
         } 
        );
      }
    );
     Future<String> prefname = SharePreference.getName();
    prefname.then((value) {
      setState(() {
        if (value != null) name = value;
      });
    });
    return Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Hello $name'),
              subtitle: Text('This is my quote "$quote"'),
            ),
            RaisedButton(
              child: Text('PROFILE SETUP'),
              onPressed: () {
                Navigator.of(context).pushNamed('/profile');
              },
            ),
            RaisedButton(
              child: Text('MY FRIENDS'),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/friend');
              },
            ),
            RaisedButton(
              child: Text('SIGN OUT'), onPressed: () {
                SharePreference.clear();
                Navigator.pushReplacementNamed(context, '/');
              },
            )
          ],
        ),
      ),
    );
  }

}