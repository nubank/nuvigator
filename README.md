# Nuvigator

[![CircleCI](https://circleci.com/gh/nubank/nuvigator/tree/master.svg?style=svg)](https://circleci.com/gh/nubank/nuvigator/tree/master)
[![Pub](https://img.shields.io/pub/v/nuvigator.svg)](https://pub.dartlang.org/packages/nuvigator)

Routing and Navigation package.


## What

This package aims to provide a powerful routing abstraction over Flutter Navigators. Using a most declarative and concise
approach you will be able to model complex navigation flows without needing to worry about several tricky behaviours
that the framework will handle for you.

Below you will find a description of the main components of this frameworks,
and how you can use they in your project.

## Main Concepts

Basic usage

```dart
@NuRouter()
class MyRouter extends BaseRouter {

  @NuRoute()
  ScreenRoute myRoute() => ScreenRoute(
    builder: (context) => MyScreen(screenContext),
  );

  @override
  Map<RouteDef, ScreenRouteBuilder> get screensMap  => _$myScreensMap(this);
}

// Wraps the top most Router into a special Router to be able to handle with DeepLinks and system behaviors. This is a
// must. Be sure to wrap your top most router into a GlobalRouter.
final router = GlobalRouter(baseRouter: MyRouter());

Widget build(BuildContext context) {
  return MaterialApp(
    builder: Nuvigator(
      router: router,
      screenType: materialScreenType,
      initialRoute: MyRoutes.myRoute,
    ), 
  );
}
```

## Nuvigator

`Nuvigator` is a custom `Navigator`, it behaves just like a normal `Navigator`, but with several custom improvements and
features. It is engineered specially to work under nested scenarios, where you can have several Flows one inside another,
it will event ensure that your Hero transitions work well under those scenarios. `Nuvigator` will be your main interface 
to interact with navigation, and  it can be easily fetched from the context, just like a normal `Navigator`, ie: `Nuvigator.of(context)`.

Nuvigator includes several extra methods that can be used, for example the `Nuvigator.of(context).openDeepLink()` methods
that will try to open the desired deepLink. Or event the `Nuvigator.of(context).closeFlow()` that will try to close a nested
Nuvigator.

Each `Nuvigator` should have a `Router`. The `Router` acts just like the routing controller. While the `Nuvigator` will
be responsible for visualization, widget render and state keeping. The Router will be Pure class that will be responsible
to provide elements to be presented and managed by the Nuvigator.

## ScreenRoute and FlowRoute

Envelopes a widget that is going to be presented as a Screen by a Nuvigator. The Screen contains a ScreenBuilder 
function, and some attributes, like screenType, that are going to be used to generate a route properly.

When creating a `ScreenRoute` it can receive a optional generic type that will be considered as the type of the value
to be returned by this Route when popped.

Screen Options:

- builder
- screenType
- wrapper

FlowRoute is just a subclass of the `ScreenRoute` that may receive a `Nuvigator` instead of a builder function. Using
the FlowRoute will allow Nuvigator to properly create all nested Nuvigator routing methods correctly.

When using `FlowRoute` you **SHOULD** declare the generic type of the `Router` that is being used by it's Nuvigator. This
is required so the static analysis is able to properly generate the code when running the builder.

## Creating Routers


Defining a new Router will probably be the what you will do the most when working with Nuvigator, so understanding how
to do it properly is important. A Router class is a class that should extend a `BaseRouter` and annotate the class with 
the `@NuRouter` annotation.

### Defining Routes
 
Inside your `MyCustomRouter` you can define your routes, each route will be represented by a
method annotated with the `@NuRoute` annotation. Those methods should return a `ScreenRoute` or a `FlowRoute`, and can
receive any number of **named** arguments, those will be used as the Arguments that should/can be passed to your route
when navigating to it.

Example:
```dart
@NuRouter()
class MyCustomRouter extends BaseRouter {
  
  @NuRoute()
  ScreenRoute firstScreen({String argumentHere}) => ScreenRoute(
    builder: (context) => MyFirstScreen(context),
  ); 
  
  @override
  Map<RouteDef, ScreenRouteBuilder> get screensMap  => _$myCustomScreensMap(this); // Will be created by generated code

}
```

### DeepLinks

The `NuRoute` annotation may receive some options, in special, the `deepLink` option is used to declare a deepLink that
will be used to access this route. The usage is the same when using a `FlowRoute`, the only changes will be in the generated
code, that will take in account the nested nuvigator.

DeepLinks support both pathParameters (using URL templates) and queryParameters. Those parameters will be passed to your
Route as arguments as Strings, so keep that in mind when declaring the Route arguments.

Example:
```dart
@NuRoute(deepLink: 'myRoute/:argumentName')
```

_Obs_: DeepLinks present in routers used in nested Nuvigators inside `FlowRoute` will **NOT** be considered and are no 
reachable. If you to create a deepLink to a flow, be sure to add it to the `@NuRoute` annotation in the Router that
declares the `FlowRoute`.

### Groped Routers

In addition to declaring Routes in your Router, you can also declare child Routers. Those routers will have it's Routes
presented as being part of the father Router. We may also refer this pattern as Router Grouping or Grouped Routers.
This allow for splitting a huge router that potentially could have many Routes, into smaller autonomous Routers that can
be imported and grouped together in the main Router.

To declare child routers you just need to add a new field with desired router type, and annotate it with the `@NuRouter`
annotation.

Example:
```dart
@NuRouter()
class MyCustomRouter extends BaseRouter {
  
  @NuRouter()
  MyOtherRouter myOtherRouter = MyOtherRouter();

  @override
  List<Router> get routers => _$myCustomRoutersList(this); // Will be created by the generated code
  @override
  Map<RouteDef, ScreenRouteBuilder> get screensMap  => _$myCustomScreensMap(this); // Will be created by generated code
}
```

### BaseRouter Options

It is a Router interface implementation with sensible defaults that should be used most of the times. `BaseRoute` includes
some options that can be used enhance the navigation experience.

When extending from the `BaseRouter` you can override the following properties to add custom behaviors to your routes:

- `deepLinkPrefix`:
A String, that will be used as prefix for the deepLinks declared on each route, and also on the grouped routers.

- `screensWrapper`:
A function to wrap each route presented by this router. Should return a new Widget that wraps this child Widget. 
The Wrapper will be applied to all Screens in this Router. (this function runs one time for each screen, and not one 
time for the entire Router).

## Code Generators

You probably noted in the examples above that we have methods that will be created by the Nuvigator generator. So while
they don't exists you can just make they return `null` or leave un-implemented. 

Before running the generator we recommend being sure that each Router is in a separated file, and also make sure that you
have added the `part 'my_custom_router.g.dart';` directive in your router file. 

After running the generator (`flutter pub run build_runner build --delete-conflicting-outputs`), you will notice that 
each router file will have it's part of file created. Now you can complete the `screensMap` and `routersList` functions
with the generated: `_$myScreensMap(this);` and `_$samplesRoutersList(this);`. Generated code will usually follow this pattern
of stripping out the `Router` part of your Router class and using the rest of the name for generated code.

Generated code includes the following features:

- Routes "enum" class
- Typed Arguments classes
- Typed ScreenInterface classes
- Navigation class
- Implementation Methods

### Routes Class

The Routes Class is a "enum" like class, that contains mapping to the generated route names for your router, eg:
```dart
class SamplesRoutes {
  static const home = 'samples/home';

  static const second = 'samples/second';
}
```

### Typed Argument Classes

Those are classes representing the arguments each route can receive. They include parse methods to extract itself from
the BuildContext. eg:

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

### Typed ScreenInterfaces Classes

It's a extension of `StatelessWidger` that can be extended by your Screen Widget. This class is make to provide easy access
to the current `Nuvigator` instance, and also to the Route arguments. eg:

```dart
abstract class SecondScreen extends ScreenWidget {
  SecondScreen(BuildContext context) : super(context);

  SecondArgs get args => SecondArgs.of(context);
  SamplesNavigation get samplesNavigation => SamplesNavigation.of(context);
}

class MySecondScreenWidget extends SecondScreen {
  MySecondScreenWidget(BuildContext context): super(context);

  Widget build(BuildContext context) {
    print(args.testId);
    // nuvigator.pop();
    ...
  }
}
```

### Navigation Class

It's a helper class that contains a bunch of typed navigation methods to navigate through your App. Each declared `@NuRoute`
will have several methods created, each for one of the existing push methods. You can also configure which methods you want
to generate using the `@NuRoute.pushMethods` parameter.

Nested flows (declared with the `FlowRoute`) will also have it's generated Navigation Class instance provided as a field
in the parent Navigation. The same applies for Grouped Routers. Usage eg:

```dart
final result = await SamplesNavigation.of(context).sampleOneNavigation.toScreenOne(testId: 'From Home');
print('RESULT $result');


SamplesNavigation.of(context).toSecond(testId: 'From Home');
```

