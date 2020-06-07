import 'package:flutter/material.dart';
import 'package:quatre_cent_vingt_et_un/screen/StartPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '421',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StartPage(), // MyHomePage(title: '421'),
    );
  }
}

