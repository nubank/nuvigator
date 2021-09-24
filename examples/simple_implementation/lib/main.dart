import 'package:flutter/material.dart';
import 'package:nuvigator/next.dart';
import 'package:simple_implementation/screens/home_screen.dart';
import 'package:simple_implementation/screens/one_screen.dart';
import 'package:simple_implementation/screens/three_screen.dart';
import 'package:simple_implementation/screens/two_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nuvigator simple example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Nuvigator.routes(
        initialRoute: 'home',
        screenType: materialScreenType,
        routes: [
          NuRouteBuilder(path: 'home', builder: (_, __, ___) => HomeScreen()),
          NuRouteBuilder(path: 'one', builder: (_, __, ___) => OneScreen()),
          NuRouteBuilder(path: 'two', builder: (_, __, ___) => TwoScreen()),
          NuRouteBuilder(path: 'three', builder: (_, __, ___) => ThreeScreen()),
        ],
      ),
    );
  }
}