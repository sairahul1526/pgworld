import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './screens/login.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  runApp(new MaterialApp(
    title: "CloudPG",
    home: new MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CloudPG',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.primaries[2],
      ),
      home: MyHomePage(title: 'CloudPG'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new Login(),
    );
  }
}
