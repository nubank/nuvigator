# Nuvigator

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
    'MyScreenRouteName': Screen.card((screenContext) => MyScreen(screenContext))
  };
}
```

```dart
class MyGlobalRouter extends GlobalRouter {
  @override
   List<Router> get routers => [
    MyRouter(),
  ];
}
```

```dart
final router = MyGlobalRouter();

Widget build(BuildContext context) {
  return MaterialApp(onChangeRoute: router.getRoute);
}
```

## Screens

Envelopes a widget that is going to be presented as a Screen by a Navigator.
The Screen contains a ScreenBuilder function, and some attributes, like transition type,
that are going to be used to generate a route properly.

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
        'test': Screen<void>.card((screenContext) => ChatHomeScreen(screenContext)),
      };

  @override
  Map<String, String> get deepLinksMap => {
        '/myGroup/test/': 'test',
      };
}
```

Options:

- `screensMap`

A Map<String, Screen> that contains the mapping between RouteNames and Screens.

- `deepLinksMap`

A Map<String, String> that contains the mapping between deeplink path and RouteNames. The keys
accept path params template notation, eg: `/myFeature/:id/details`

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

### Writing Custom Routers

## Flows

You will find the `FlowRouter` that can be used as a Mixin for any SimpleRouter subclass
this Mixin enables the Router to present it's screens in a nested Navigator
as a new Flow in the App. Flow Routers are a very powerful abstraction
that enables any Router to easily become a Flow coordinator.

Example:

```dart
class MyRouter extends SimpleRouter with FlowRouter<void> {
  @override
  Map<String, Screen> get screensMap  => {
    'MyScreenRouteName': Screen.card<void>((screenContext) => MyScreen(screenContext))
  };
}
```

Options:

(All from the extendend Router plus)

- `transitionType`

The Transition type that will be used to present the flow with the first screen already mounted.

- `flowWrapper`

Overridable function that will provide a Wrapper for the entire Flow.
Useful for providing information to the context that will be shared by all
flow screens.

- `initialRouteName`

RouteName of the first Screen of this Flow, will permit the usage of the
method: `flowRouter.initialScreen` to get the initial screen of this Flow. 


## NavigationService

Is an abstraction created to help you navigate through Screens. Every ScreenWidget will receive a ScreenContext, that
contains an instance of a `NavigationService`. NavigationService contains custom `pushNamed`, `pop` and others methods 
for navigating inside the Navigators. NavigationService will handle properly Nested Navigators, Flows and other tricky
behaviours originated from complex Navigation structures.

Always use the `NavigationService` when wanting to navigate!

`NavigationService` can be extended (and usually is encouraged) to include custom navigation methods with already typed
params and responses. 

