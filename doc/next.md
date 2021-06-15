# Nuvigator Next API Documentation

Nuvigator is passing through a major revamp in it's API, to be able to provide a more dynamic and easy to use
experience. The core functional features of Nuvigator are going to be kept, and improved, but the development API is
going to change drastically. Right now both APIs (legacy and next) can coexist, but it's preferred to use the NEXT API
when developing new flows.

Não fala bem inglês? Leia o [next_PT](./next_PT.md)

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

## Defining Routes

Routes represent a reachable screen in your application, routes are represented by the `NuRoute` class. Each `NuRoute`
should at least provide it's full path, and a build method. There are other optional properties that can specified in
a `NuRoute`.

### NuRoute

To create your Route, you should extend the `NuRoute` class and implement (at least) the required overrides.

Example:

```dart
class MyRoute extends NuRoute<NuRouter, MyArguments, MyReturn> {
  // Optional - If your Router enforces a synchronous initialization this should return an instance of a SynchronousFuture
  @override
  Future<bool> init(BuildContext context) async {
    // Do something
    return true; // return true to register the route
  }

  // Optional - will use the Router default if not provided
  @override
  ScreenType get screenType => materialScreenType;

  // Optional - converts deepLink params to MyArguments class
  @override
  ParamsParser<MyArguments> get paramsParser => _$paramsParser;

  // Optional - The the provided path should be matched as a prefix, instead of exact
  @override
  bool get prefix => false;

  // Path of this route
  @override
  String get path => 'my-route';

  // What this route will render
  @override
  Widget build(BuildContext context, NuRouteSettings settings) {
    // Inside the NuRouter subclass you have access to the `nuvigator` and `router` that this route is attached to.
    return MyScreen(
      onClick: () => nuvigator.open('next-route'),
    );
  }
}
```

Inside the you `NuRoute` subclass you have access to the `NuRouter` it's registered and typed by the provided typing argument.
You can also use the `NuRoute.nuvigator` getter to access the Nuvigator in which this `NuRoute` is being presented.

### Route Path

Route paths are used as DeepLinks and can have path parameters to be matched against them. Path Parameters are going to be extracted and made available in the `NuRouteSettings` provided to the `NuRoute.build` function.

To declare a Path Parameter you can use the `:` syntax, example:

```dart
String get path => 'myRoute/:pathParam'
```

If you override the `prefix` property in the `NuRoute` to `true` the route path is going to be matched as prefix (in regex terms: `<yourPath>.*`). This can be useful if you have a nested Nuvigator that will match against the complete path, making possible nested Deep Link navigation.

### NuRouteSettings

This class is a subclass of the regular Flutter `RouteSettings`, but it includes extra information and details from the matched Deep Link against the Route Path. `NuRouteSettings` accepts a generic type that regards the class that contains the parsed arguments from the Route.

In the `NuRoute` class you can a `NuRoute.paramsParser` function that will receive raw parameters in `Map<String, dynamic>` and should return an instance of the declared Arguments class in you `NuRoute` subclass typing.

### NuRoute Initialization

Every `NuRoute` can override the `init(BuildContext context)` method, that allows for an asynchronous initialization of
it when its corresponding `Nuvigator` is first presented.

**Important**: The `init` function is going to be executed when the `Nuvigator` in which this `NuRoute` is contained is
presented, and not when the `NuRoute` is presented.

You can use this function to fetch some information or prepare a common state that will need to be used when the Route
is going to be presented.

While all `NuRoute`s are initializing a `loadingWidget` (provided by the `Nuvigator` corresponding `NuRouter`) is going
to be presented.

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

To create your Router, you should extend the `NuRouter` class, and implement the required methods.

```dart
class MyRouter extends NuRouter {

  // The initialRoute path that should be rendered by this Router Nuvigator
  @override
  String get initialRoute => 'home';

  // The list of NuRoutes that will be available in this Router.
  // Important: This method should return a new instance of the NuRoute, do not re-utilize instances
  @override
  List<NuRoute> get registerRoutes => [

  ];

  // Optional - Default ScreenType to be used when a route does not specify
  @override
  ScreenType get screenType => materialScreenType;

  // Optional - Custom initialization function of this Router
  @override
  Future<void> init(BuildContext context) {
    return SynchronousFuture(null);
  }

  // Optional (defaults to true) - Enables/Disables support for asynchronous initialization (will display the loading widget)
  @override
  bool get awaitForInit => true;

  // Optional - If asynchronous initialization is enabled, the widget will be rendered while the Router/Routes initialize
  @override
  Widget get loadingWidget => Container();

  // Optional - If no Route is found for the requested deepLink then this function will be called
  @override
  DeepLinkHandlerFn get onDeepLinkNotFound => null

  // Optional - If the Router initialization fails this function will be called, and it should return a Widget to be rendered instead of the Nuvigator
  Widget onError(Error error, NuRouterController controller) => null;

  // Optional - Register legacy NuRouters
  @override
  List<INuRouter> get legacyRouters => [

  ];
}
```

### NuRouter Initialization and Loading

Similar to the `NuRoute` initialization, the `NuRouter` can perform some asynchronous initialization when it's `Nuvigator`
is first presented. During the initialization the `loadingWidget` will be rendered instead of the Nuvigator.

If for some reason you do not want to support asynchronous initialization, you can override the `awaitForInit` getter, and all init methods from NuRoute and the own init from the NuRoute will need to return a `SynchronousFuture`.

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

`Nuvigator` is a `Navigator` subclass that offers nested navigation capabilities and improvements in a transparent way.
Every `Nuvigator` have a corresponding `NuRouter` that is responsible for controlling it's routing logic. Other than that,
a `Nuvigator` shall behave very similar to a regular `Navigator`.

### Nested Behaviors

Big part of what Nuvigator does is related to scenarios where you have nested Nuvigators.

**Opening DeepLinks**

When you try to open a deepLink, Nuvigator will try to find a route that matches the provided deepLink from the closest Nuvigator, to the root one. This enables for calling deepLink from anywhere in your application, without needing to know how deeply nested your screen is in relationship to the Nuvigator/Router that can display the requested deepLink.

**Popping Screens**

If you are inside a nested Nuvigator and calls the `.pop` method (or variations), instead of doing nothing, it will close the nested Nuvigator, returning to the parent one. This enables for transparent navigation between nested flows.

Another relevant point here is that the value passed to the `.pop` function, will be passed downstream, making your nested flow return this value to the screen that requested it's opening.

**Android Back Button**

When the Android back button is pressed Nuvigator will ensure that just the deepest Nuvigator responds to it, popping it's current screen (instead of the Root Nuvigator)

**Hero Animations**

Nuvigator comes with built in support for Here animations that happens betweens different levels of nested Nuvigators.

### Navigating

Prefer using the `NuvigatorState.open` method when wanting to navigating to another route using it's deepLink. In case the deepLink contains a scheme (`nuapp://my-route`, `nuapp://` is the scheme part here), it will be stripped and not considered as part of the deepLink for navigation purposed.

Example:

```dart
// Gets your NuvigatorState instance (can be obtained from inside NuRouters/NuRoutes without the need of context)
final nuvigator = Nuvigator.of(context);
final result = await nuvigator.open<String>('nuapp://next-screen');
```

`.open` accept a few options in addition to the deepLink itself:

- pushMethod (default: DeepLinkPushMethod.Push)
Allows to customize how the route will be pushed into the Navigation Stack, available options are: Push, PushReplacement, PopAndPush

- screenType
Allows to override the ScreenType that is going to be used to present the Route to be opened

- parameters
Additional parameters to be passed to the Route (will be merged with the query+path parameters)


### Nuvigator.routes

Helper factory to create `Nuvigator` from a List of `NuRoute`s, just like a `NuRouterBuilder`.

Example:

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

## ScreenTypes

ScreenType is the class Nuvigator used to help you define how your NuRoute is going to be presented. It acts as an adapter between the Widget Builder and the Navigator Route to be presented. ScreenTypes allows you to define customer transitions/presentation behavior in a declarative manner. By default Nuvigator provides two default ScreenTypes:

- MaterialScreenType
- CupertinoScreenType

But you can create your own ScreenTypes by extending the `ScreenType` class, and implementing the `toRoute` method. This method should return a `Route` subclass, one additional functionality is the `NuvigatorPageRoute` mixin, that can be used to improve the stack awareness of `PageRoute`s that implement it, when inside Nuvigators. One example of custom ScreenType behavior can be found below:

```dart
class _NuMaterialPageRoute<T> extends MaterialPageRoute<T> with NuvigatorPageRoute<T> {
  _NuMaterialPageRoute({
    @required WidgetBuilder builder,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
          builder: builder,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        );
}

class MaterialScreenType extends ScreenType {
  const MaterialScreenType();

  @override
  Route<T> toRoute<T extends Object>(
      WidgetBuilder builder, RouteSettings settings) {
    return _NuMaterialPageRoute(
      builder: builder,
      settings: settings,
    );
  }
}
```

## Legacy Interop

The next API offers a way to interop with the legacy Router API, this can facilitate the migration of the project to be
done by parts.

Just registers yours legacy `NuRouter`s under the `legacyRouters` getter in the new `NuRouter` class.

```dart
import 'package:nuvigator/next.dart';

class MyRouter extends NuRouter {
  // ...

  List<INuRouter> get legacyRouters => [
    MyLegacyRouter(),
  ];

// ...
}
```

This will ensure that when no route is found using the new API (for both deepLinks and routeNames), the old API will be
used to try to locate it.
