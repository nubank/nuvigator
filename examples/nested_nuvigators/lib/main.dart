import 'package:nested_nuvigators/flows/first_flow/route.dart';
import 'package:nested_nuvigators/flows/second_flow/route.dart';
import 'package:nuvigator/next.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nested nuvigators',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Nuvigator.routes(
        initialRoute: 'home',
        screenType: materialScreenType,
        routes: [
          HomeRoute(),
          FirstFlowRoute(),
          SecondFlowRoute(),
        ],
      ),
    );
  }
}

class HomeRoute extends NuRoute {
  @override
  String get path => 'home';

  @override
  ScreenType get screenType => materialScreenType;

  @override
  Widget build(BuildContext context, NuRouteSettings<Object> settings) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nuvigator simple example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Tap a button to change the page',
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text('First Flow'),
              onPressed: () => nuvigator.open('first-flow'),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text('Second Flow'),
              onPressed: () => nuvigator.open('second-flow'),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
