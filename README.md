# Nuvigator

[![CircleCI](https://circleci.com/gh/nubank/nuvigator/tree/master.svg?style=svg)](https://circleci.com/gh/nubank/nuvigator/tree/master)
[![Pub](https://img.shields.io/pub/v/nuvigator.svg)](https://pub.dartlang.org/packages/nuvigator)

Routing and Navigation package.

Não fala bem inglês? Leia o [README_PT](./README_PT.md)

## What

Nuvigator provides a powerful routing abstraction over Flutter's own Navigators. Model complex navigation flows using a mostly declarative and concise approach, without needing to worry about several tricky behaviors that Nuvigator handles for you.

Nuvigator can help you with:

- Large/Modular Apps: Where you need to have an unified API to able to register routes and design relationship between them
- Nested Navigation: When you want to have nested/children Navigator inside your app, creating the concept of self contained flows
  - Handles Navigation thought Nuvigator ins your Widget Tree, not need to know where your route is declared
  - Handles pop behavior when a nested Navigator reaches it's end, is able to transparently forward pop results into underlying caller, provider helpers to deal with nested navigation
  - Handles Hero animation/transition between nested Navigators
  - Handles Android back button correctly on nested Navigators
  - Improve support for nested PageRoutes with NuvigatorPageRoute mixin
- Using DeepLinks: You want to navigate inside your App using DeepLinks, with support for Path Parameters and Query Parameters
- A declarative, easy to use API to declare and compose Routes together

[**API Documentation**](./doc/next.md)
> Focus on providing a more flexible, easier and dynamic API for declaring Navigation and Routing

## Quick Start

The simplest you can get:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nuvigator App',
      builder: Nuvigator.routes(
        initialRoute: 'home',
        routes: [
          NuRouteBuilder(path: 'home', builder: (_, __, ___) => HomeScreen()),
          NuRouteBuilder(path: 'second', builder: (_, __, ___) => SecondScreen()),
        ],
      ),
    );
  }
}
```

A more complete example:

```dart
import 'package:nuvigator/next.dart'; // import the next file instead of `nuvigator.dart`
import 'package:flutter/material.dart';

// Define a new NuRoute
class MyRoute extends NuRoute {
  @override
  String get path => 'my-route';

  @override
  ScreenType get screenType => materialScreenType;

  @override
  Widget build(BuildContext context, NuRouteSettings settings) {
    return MyScreen(
      onClick: () => nuvigator.open('next-route'),
    );
  }
}

// Define your NuRouter
class MyRouter extends NuRouter {
  @override
  String get initialRoute => 'my-route';

  @override
  List<NuRoute> get registerRoutes => [
    MyRoute(),
  ];
}

// Render
Widget build(BuildContext context) {
  return Nuvigator(
    router: MyRouter(),
  );
}

```

# License
[Apache License 2.0](LICENSE)
