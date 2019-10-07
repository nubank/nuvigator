# Nuvigator

[![CircleCI](https://circleci.com/gh/nubank/nuvigator/tree/master.svg?style=svg&circle-token=55aa922fdac1237c4a0081776e09431213884247)](https://circleci.com/gh/nubank/nuvigator/tree/master)

Routing and Navigation package.

## What

This package aims to provide a powerful routing abstraction over Flutter
Navigators. Using a most declarative and concise approach you will be able
to model complex navigation flows without needing to worry about several
complex aspects and tricky behaviours that the framework will handle for you.

Below you will find a description of the main components of this frameworks,
and how you can use they in your project.

## Main Concepts

Basic usage

```dart
class MyRouter extends SimpleRouter {
  @override
  Map<String, Screen> get screensMap  => {
    'MyScreenRouteName': Screen(
      builder: (screenContext) => MyScreen(screenContext),
    ),
  };
}

final router = MyGlobalRouter(routers: [MyRouter()]);

Widget build(BuildContext context) {
  return MaterialApp(
    builder: Nuvigator(
      router: router,
      screenType: materialScreenType,
      initialRoute: 'MyScreenRouteName',
    ), 
  );
}
```

## Nuvigator

`Nuvigator` is a custom `Navigator`, it behaves just like a normal `Navigator`, but with several
custom improvements and features. It is engineered specially to work under nested scenarios, where
you can have several Flows one inside another. `Nuvigator` will be your main interface to interact with navigation, and it can be easily fetched from
the context, just like a normal `Navigator`, ie: `Nuvigator.of(context)`.

Each `Nuvigator` should have a `Router`. The `Router` acts just like the routing controller. While
the `Nuvigator` will be responsible for visualization, widget render and state keeping. The Router
will be Pure class that will be responsible to provide elements to be presented and managed by the Nuvigator.

## Screens

Envelopes a widget that is going to be presented as a Screen by a Navigator.
The Screen contains a ScreenBuilder function, and some attributes, like transition type,
that are going to be used to generate a route properly.

Screen Options:

- builder
- screenType
- deepLink
- wrapperFn

## Routers

### Interface

A Router is just a interface that aims to provide a screen for a given route name.

```dart
abstract class Router {
  Screen getScreen({String routeName});

  Future<DeepLinkFlow> getDeepLinkFlowForUrl(String url) => null;
}
```

Below you will find some implementations of this Interface that can be used to define the Routing in you application.

### SimpleRouter

Basic Usage:

```dart
class ChatRouter extends SimpleRouter {
  @override
  Map<String, Screen> get screensMap => {
        'test': Screen(
            builder: (screenContext) => ChatHomeScreen(screenContext),
            screenType: materialScreenType,
            deepLink: '/myGroup/test/', 
          ),
      };
}
```

Options:

- `screensMap`

A Map<String, Screen> that contains the mapping between RouteNames and Screens.

- `deepLinkPrefix`

A String, that will be used as prefix for every entry key at the `deepLinksMaps`.

- `screenWrapper`

A function that will receives a ScreenContext and a child Widget. Should return a new Widget
that wraps this child Widget. The Wrapper will be applied to all Screens in this Router.
(this function runs one time for each screen, and not one time for the entire Router).


### GroupRouter

`GroupRouter` extends the `SimpleRouter` so, every option of the SimpleRouter can be used here. In addition to that
the `GroupRouter` supports a list if child `Routers` to be iterated in the case of itself not being able to resolve
the requested RouteName.

```dart

class LendingRouter extends GroupRouter {

  @override
  List<Router> get routers => [
    ChatRouter(),
  ];

}

```

Options:

All from `SimpleRouter` plus:

- `routers`

A `List<Router>` that will be called in the case of the GroupRouter itself not being able to resolve the RouteName.

- `deepLinkPrefix`

Behaves like the one in the `SimpleRouter`, but in the case of the DeepLink being dispatched to the child `routers`, it
will have this prefix trimmed/removed before sending down it.
