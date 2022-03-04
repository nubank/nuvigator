# Migrating to next API

This document aims to highlight some paths to migrate your codebase from the legacy generator API to the Next API. It's important to understand the new options and changes in the new API, so we recommend going through the [NEXT API DOC](next.md).

To use the new API update the package import to use the following:

```dart
import 'package:nuvigator/next.dart'; // Use next.dart instead of nuvigator.dart
```

## From Route Methods to NuRoute classes

In the old API each route was generated based on an `@NuRoute` annotated method inside a `NuRouter` class.

```dart
@nuRouter
class MyRouter extends NuRouter {
  // ...
  @NuRoute(deepLink: 'myDeepLink')
  ScreenRoute myRoute() => ScreenRoute(
    screenType: materialScreenType,
    builder: (context) => Widget(),
  );
  // ...
}
```

Now each route can be extracted into it's own class, that should extend the `NuRoute` class, and the new `NuRouter` should contain the routes to be registered into it.

```dart
class MyRoute extends NuRoute {
  @override
  String get path => 'myDeepLink';

  @override
  ScreenType get screenType => materialScreenType;

  @override
  Widget build(BuildContext context, NuRouteSettings settings) {
    return Widget();
  }
}

class MyRouter extends NuRouter {
  // ...
  @override
  List<NuRoute> get registerRoutes => [
    MyRoute() // Be sure to always return a new instance of the Route class here.
  ];
  // ...
}
```

You can also use the inline builder variations (`NuRouteBuilder` and `NuRouterBuilder`), as explained in the NEXT API Documentation.

## DeepLinks and RouteNames

In the new API both concepts were unified. You `NuRoute` path is it's deepLink, so it supports the path parameters as expected.

When using `pushNamed` you can provide the deepLink and it would be resolved correctly. However we incentivize the usage of `NuvigatorState.open` instead, given it has a better support.

**Important:** The deepLinkPrefix functionality DO NOT exists anymore, so every route should declare the complete deepLink, example:

Before:
```dart
@nuRouter
class MyRouter extends NuRouter {
  @override
  String get deepLinkPrefix => 'myFlow';

  @NuRoute(deepLink: '/home')
  ScreenRoute homeRoute() => // ..

  @NuRoute(deepLink: '/second')
  ScreenRoute secondRoute() => // ..
}
```

Now:
```dart
class MyRoute extends NuRouter {
  @override
  List<NuRoute> get registerRoutes => [
    NuRouteBuilder(
      path: 'myFlow/home',
      builder: //...
    ),
    NuRouteBuilder(
      path: 'myFlow/second',
      builder: // ...
    ),
  ];
}
```

## ScreensWrapper

When using Next API you can override the `buildWrapper` method to wrap the `builder` function of the NuRoutes registered
in the router with another Widget.
