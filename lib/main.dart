import 'package:flutter/material.dart';
import 'package:nooble/Screens/FeedScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Nooble",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: FeedScreen(),
    );
  }
}

