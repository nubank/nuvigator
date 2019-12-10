# Route Argument/Parameters

Passing arguments to Routes is a pretty common task done during Navigation, and as the App grows and starts to have more
Routes it can become hard task identifying what arguments needs to be passed to a Route so it can be rendered properly.

To solve this problem Nuvigator aims to provide a static typed interface to navigate between Routes, where you can have
generated helpers that ensure you are passing the the right data for the desired screen.

When creating a new Route it can be daunting at first on how we can obtain the parameters passed to it, or how we can
provide it. This document will guide you trough all the available options.

Before starting it's good to make clear that Nuvigator works with any of the vanilla ways of passing or retrieving arguments
when using normal `Navigators`, and also, it provides several options to access they in a strongly typed way, the form that will
select to use depends exclusively by your preferences and architecture choices.

## Declaring Route Arguments

Given we have a Route, to declare that this Route expects arguments we just need to app **named** arguments to the function
that represent it.

```dart
@NuRoute()
  ScreenRoute tutorialRoute({String myArgument, @required String anotherArgument}) => ScreenRoute(
        builder: (_) => TutorialScreen(),
      );
```

The types, name and `@required` annotation are propagated into the navigation helper.

## Passing Arguments to a Route

### Using the typed navigation helpers (Recommended)

When we declare a new Router that contains a set of Routes, the Nuvigator generator will handle generating a set of helpers
to navigate to it's routes.

> **Naming Convention**
>
> Given we have a Router named TutorialRouter, the navigation class will be called TutorialNavigation.

We can get the Navigation by using `TutorialNavigation.of(context)`, this will retrieve the desired Navigation instance.

```dart
final tutorialNavigation = TutorialNavigation.of(context);
```

With the Navigation in hands, you will be able to call the typed push method, in this case:

```dart
tutorialNavigation.toTutorialRouter(myArgument: 'testing', anotherArgument: 'arguments');
```

In Nuvigator arguments are serialized into a `Map<String, dynamic>` before being passed to the Route.

## Retrieving Arguments by a Route

### Using the Screen abstract class extension

Each Route will have a helper Screen class that can be used if you are using Screens pattern. This abstract class
is just an extension of StatelessWidget, but with some additional data available.

There are 3 class properties that you can access:
- `args` - Arguments provided to this Route.
- `nuvigator` - The closest Nuvigator, the as `Nuvigator.of(context)`.
- `tutorialNavigation` - The Navigation helper class of the Router in which this Route is included.

```dart

class TutorialScreen extends TutorialRouteScreen {
  TutorialScreen(BuildContext context) : super(context);

  @override
  Widget build(BuildContext context) {
    print(args);
//  nuvigator.
//  tutorialNavigation
  }
}
```

### Using the Arguments helper class

Each Route with arguments declared will have a Arguments helper class generated for it. The naming convention is the 
RouteName + Args, eg: `TutorialRouteArgs`.

This class has a static method that can be used to retrieve and parse the arguments of this Route from the context.
Anywhere inside the Route you can use `TutorialRouteArgs.from(context)` to get a typed object with the arguments provided
to this Route.

### Using the arguments provided by the Route method

If wished you can use the arguments straight away from the route method declaration:

```dart
@NuRoute()
  ScreenRoute tutorialRoute({String myArgument, @required String anotherArgument}) => ScreenRoute(
        builder: (_) => TutorialScreen(myArgument: myArgument, anotherArgument: anotherArgument),
      );
```
