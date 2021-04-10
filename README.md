# Nuvigator

[![CircleCI](https://circleci.com/gh/nubank/nuvigator/tree/master.svg?style=svg)](https://circleci.com/gh/nubank/nuvigator/tree/master)
[![Pub](https://img.shields.io/pub/v/nuvigator.svg)](https://pub.dartlang.org/packages/nuvigator)

Routing and Navigation package.

## What

Nuvigator provides a powerful routing abstraction over Flutter's own Navigators. Model complex navigation flows using a mostly declarative and concise approach, without needing to worry about several tricky behaviors that Nuvigator handles for you.

[**For the NEXT API Documentation**](./doc/next.md)
> Focus on providing a more flexible, easier and dynamic API for declaring Navigation and Routing

[**For the Legacy API Documentation**](./doc/legacy.md)
> An API that is based on static typed methods and generators. It's considered deprecated and will eventually be removed

## Quick Start

The simplest you can get:

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Nuvigator.routes(
      initialRoute: 'home',
      routes: [
          NuRouteBuilder(path: 'home', builder: (_, __, ___) => HomeScreen()),
          NuRouteBuilder(path: 'second', builder: (_, __, ___) => SecondScreen()),
      ],
    ),
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
