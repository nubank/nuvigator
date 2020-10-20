# Nuvigator

[![CircleCI](https://circleci.com/gh/nubank/nuvigator/tree/master.svg?style=svg)](https://circleci.com/gh/nubank/nuvigator/tree/master)
[![Pub](https://img.shields.io/pub/v/nuvigator.svg)](https://pub.dartlang.org/packages/nuvigator)

Routing and Navigation package.

## What

Nuvigator provides a powerful routing abstraction over Flutter's own Navigators. Model complex navigation flows using a mostly
declarative and concise approach, without needing to worry about several tricky behaviors that Nuvigator handles for you.

## Main Concepts

Basic usage

```dart
import 'package:flutter/widgets.dart';
import 'package:nuvigator/nuvigator.dart';

class MyScreen extends StatelessWidget {

  @override
  Widget build(BuildContext) {
    return Text('Hello Nuvigator!'); // Your regular Flutter Widget
  }

}

@nuRouter
class MainRouter extends NuRouter {

  @NuRoute()
  ScreenRoute myRoute() => ScreenRoute(
    builder: (_) => MyScreen(),
  );

  @override
  Map<RouteDef, ScreenRouteBuilder> get screensMap  => _$screensMap;
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: Nuvigator(
        router: MainRouter(),
        screenType: materialScreenType,
        initialRoute: MainRoutes.myRoute,
      ), 
    );
  }
}

```

## Nuvigator and NuRouter

`Nuvigator` is a custom `Navigator`. It behaves just like a normal `Navigator`, but has several custom improvements and
features. It is engineered specially to work under nested scenarios, where you can have several Flows one inside another.
It also ensures your Hero transitions work well under these scenarios. `Nuvigator` is your main interface to interact with
navigation, and it can be easily fetched from the context, just like a normal `Navigator`, using `Nuvigator.of(context)`.

Nuvigator includes several extra methods, like `Nuvigator.of(context).openDeepLink()` that tries to open the desired deep link.
Another example is `Nuvigator.of(context).closeFlow()` that tries to close all screens of a nested Nuvigator.

Each `Nuvigator` should have a `NuRouter`. The `NuRouter` acts as a routing controller. A `Nuvigator` is responsible for
visualization, widget rendering and state keeping. A NuRouter is a Pure class that is responsible for providing elements to
be presented and managed by the Nuvigator.

## ScreenRoute

`ScreenRoute` envelopes a widget that is going to be presented as a Screen by a Nuvigator. The Screen contains a ScreenBuilder 
function and some attributes, like `screenType`, that are going to be used to generate a route properly.

When creating a `ScreenRoute` it can receive an optional generic type that is considered as the type of the value
to be returned by this Route when popped.

Screen Options:

- `builder`: takes in the `context` and returns the widget to be presented as the Screen of the route.
- `screenType`: describes how the screen should be presented.
- `wrapper`: optionally wrap the widgets returned by `builder`. Takes in the `context` and a `child`.

A `ScreenRoute` may return another `Nuvigator`. This is useful for defining a nested flow that, when finished, can dismiss itself.

## Creating Routers

Defining a new NuRouter is probably be the what you will do the most when working with Nuvigator, so understanding how
to do it properly is important. A NuRouter class is a class that extends a `NuRouter` and is annotated with the `@nuRouter` annotation.

### Defining Routes
 
In the example, inside your `MyCustomRouter` we define our routes. Each route is represented by a method annotated with the `@NuRoute`
annotation. These methods should return a `ScreenRoute` and can receive any number of **named** arguments. These arguments are used as
the Arguments that can be passed to your route when navigating to it.

Example:
```dart
@nuRouter
class MyCustomRouter extends NuRouter {
  
  @NuRoute()
  ScreenRoute firstScreen({String argumentHere}) => ScreenRoute(
    builder: (_) => MyFirstScreen(),
  ); 
  
  @override
  Map<RouteDef, ScreenRouteBuilder> get screensMap  => _$screensMap; // Will be created by generated code

}
```

### Deep links

The `NuRoute` annotation may receive some options. In particular, the `deepLink` option is used to declare a deep link that
can be used to access this route. The usage is the same when using a nested nuvigator, the only changes are in the generated
code, that takes into account the nesting and properly defines the deep link path.

Deep links support both `pathParameters` (using URL templates) and `queryParameters`. Depending on the type of these parameters,
they'll be passed to the Route's arguments either as their proper type or as Strings. Currently, Nuvigator can handle the following
types natively for parameters in a deep link:

- int (`?number=42`)
- double (`?number=42.5`)
- bool (`?active=true`, `?active=false`)
- DateTime (`?date=2020-10-01`, `?date=2020-10-01T15:32:09.123Z`)
- String (`?name=Jane+Doe`)

Any of these **can be null** if you try to open a deep link without specifying them **or if they fail to parse** (e.g. `false` as a bool outputs `null`).

If you create a Route that takes an argument of a different type and it has a deep link, Nuvigator's code generation tool will issue
a warning about it. This is because, when decoding something that is not declared as one of these types, the result **will be a String**.
When you open the route using a function call, it expects the properly typed argument but when opening via deep link it receives
a String.

As of now, if you want a route to have a deep link and it takes parameters of types not in the list above, the safest solution is expecting
a String and doing the parsing in the Route. We don't have yet a way to define custom parsing for different types. This issue does not
exist if the route does not declare a deep link.

Example:
```dart
@NuRoute(deepLink: 'myRoute/:argumentName')
```

ℹ️ Note: Deep links contained in routers that are used in nested Nuvigators will **not** be considered and are not reachable. If you
want to create a deepLink to a flow, be sure to add it to the `@NuRoute` annotation in the Router that declares the nested `Nuvigator`.

### Grouped Routers

In addition to declaring Routes in your Router, you can also declare child Routers. These routers have its Routes
presented as being part of the parent Router. We may also refer this pattern as Router Grouping or Grouped Routers.
This allows for splitting a huge router that potentially could have many Routes, into smaller autonomous Routers that can
be imported and grouped together in the main Router.

To declare child routers you just need to add a new field with desired router type, and annotate it with the `@NuRouter`
annotation.

Example:
```dart
@nuRouter
class MyCustomRouter extends NuRouter {
  
  @nuRouter
  MyOtherRouter myOtherRouter = MyOtherRouter();

  @override
  List<Router> get routers => _$routers; // Will be created by the generated code
  @override
  Map<RouteDef, ScreenRouteBuilder> get screensMap  => _$screensMap; // Will be created by generated code
}
```

### Router Options

When extending from the `NuRouter` you can override the following properties to add custom behaviors to your routes:

- `deepLinkPrefix`:
A `Future<String>`, that is used as prefix for the deep links declared on each route, and also for the grouped routers.

- `screensWrapper`:
A function to wrap each route presented by this router. Should return a new Widget that wraps this child Widget. 
The Wrapper is applied to all Screens in this NuRouter. This function runs one time for each screen, and not one 
time for the entire NuRouter.

- `routers`
Sub-Routers grouped into this NuRouter.

## Code Generators

You may have noticed in the examples above that we have methods that will be created by the Nuvigator generator. So while
they don't exists you can just make they return `null` or leave un-implemented. 

Before running the generator we recommend being sure that each NuRouter is in a separated file, and also make sure that you
have added the `part 'my_custom_router.g.dart';` directive and the required imports (`package:nuvigator/nuvigator.dart` and `package:flutter/widgets.dart`) in your router file. 

After running the generator (`flutter pub run build_runner build --delete-conflicting-outputs`), you should notice that 
each router file will have its `part-of` file created. Now you can complete the `screensMap` and `routersList` functions
with the generated: `_$myScreensMap(this);` and `_$samplesRoutersList(this);`. Generated code usually follows this pattern
of stripping out the `NuRouter` part of your NuRouter class and using the rest of the name for generated code.

Generated code includes the following features:

- Routes Enum-like class
- Navigation extension methods to NuRouter
- Typed Arguments classes
- Implementation Methods

### Routes Class

The Routes Class is an autogenerated Enum-like class that contains a mapping to the generated route names for your router.
You can use it as a way of not hardcoding route names.

```dart
class SamplesRoutes {
  static const home = 'samples/home';

  static const second = 'samples/second';
}
```

### Typed Argument Classes

These are classes representing the arguments each route can receive. They include parse methods to extract themselves from
the BuildContext.

```dart
class SecondArgs {
  SecondArgs({@required this.testId});

  final String testId;

  static SecondArgs parse(Map<String, Object> args) {
    ...
  }

  static SecondArgs of(BuildContext context) {
    ...
  }
}
```

### Navigation Extensions

It's a helper class that contains a bunch of typed navigation methods to navigate through your App. Each declared `@NuRoute`
will have several methods created, each for one of the existing push methods. You can also configure which methods you want
to generate using the `@NuRoute.pushMethods` parameter.

Nested flows (declared with nested Nuvigators) will also have their generated Navigation Class instance provided as a field
in the parent Navigation. The same applies for Grouped Routers. Usage eg:

```dart
final router = NuRouter.of<SamplesRouter>(context);
await router.sampleOneRouter.toScreenOne(testId: 'From Home');
await router.toSecond(testId: 'From Home');
```
