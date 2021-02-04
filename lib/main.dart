import 'package:flutter/material.dart';
import 'package:web2/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'I Know Everything',
      theme: ThemeData(

        primarySwatch: Colors.teal,
      ),
      home: HomePage() ,
    );
  }
}



