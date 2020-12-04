# Nuvigator Next API

Nuvigator is passing through a major revamp in it's API, to be able to provide a more dynamic and easy to use
experience. The core functional features of Nuvigator are going to be kept, and improved, but the development API is
going to change drastically. Right now both APIs (legacy and next) can coexist, but it's preferred to use the NEXT API
when developing new flows.

## Quick Start

```dart
import 'package:nuvigator/next.dart'; // import the next file instead of the nuvigator.dart
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

```

## Defining Routes

Routes represent a reachable screen in your application, routes are represented by the `NuRoute` class. Each `NuRoute`
should at least provide it's full path, and a build method. There are other optional properties that can specified in
a `NuRoute`.

### NuRoute

To create your Route, you should extend the `NuRoute` class and implement (at least) the required overrides.

Example:

```dart
```

Inside your `NuRoute` class you will have access to the the `NuRouter` and `Nuvigator` that is presenting it.

### NuRoute Initialization

Every `NuRoute` can override the `init(BuildContext context)` method, that allows for an asynchronous initialization of it
when its corresponding `Nuvigator` is first presented.

**Important**: The `init` function is going to be executed when the `Nuvigator` in which this `NuRoute` is contained is presented,
and not when the `NuRoute` is presented.

You can use this function to fetch some information or prepare a common state that will need to be used when the Route is going
to be presented.

While all `NuRoute`s are initializing a `loadingWidget` (provided by the `Nuvigator` corresponding `NuRouter`) is going to be
presented.

### NuRouteBuilder

You can define inline Routes using a `NuRouteBuilder` this approach is usually better suited for smaller flows or Routes
that do not require any kind of initialization process.

Example:

```dart
import 'package:nuvigator/next.dart';

class MyRouter extends NuRouter {

  @override
  String get initialRoute => 'my-route-path';
  
  @override
  List<NuRoute> get registerRoutes => [
        NuRouteBuilder(
          path: 'my-route-path',
          screenType: materialScreenType,
          builder: (context, route, settings) => Container(),
        ),
      ];

}
```

## Routers

Modules are a grouping of `NuRoute`s, there are provided to the `Nuvigator` as it's controller. `NuModules` can
implement custom initialization functions and configure itself correctly before the `Nuvigator` is presented.

### NuRouter

### NuRouter Initialization and Loading

### NuRouterBuilder

The same way you can define `NuRoute`s inline, you can do the same with a `NuRouter`.

```dart
class MyWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Nuvigator(
      router: NuRouterBuilder(
        initialRoute: 'home',
        routes: [
          HomeRoute(),
          MyRoute(),
        ],
      ),
    );
  }
}
```

You can combine `NuRouterBuilder` with `NuRouteBuilder` to reach a completely inline and dynamic approach.

## Nuvigator

### Navigating

Using the `NuvigatorState.open` method.

### Nuvigator.routes

Helper factory to create `Nuvigator` from a List of `NuRoute`s, just like a `NuRouterBuilder`.
