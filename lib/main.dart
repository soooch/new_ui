import 'package:flutter/material.dart';
import 'screens/switcher.dart';
import 'screens/app.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "New UI",
      home: SwitcherView(),
      theme: ThemeData.from(
          colorScheme:
              ThemeData.light().colorScheme.copyWith(background: Colors.white),
          textTheme: ThemeData.light().textTheme),
      darkTheme: ThemeData.dark(),
    );
  }
}
