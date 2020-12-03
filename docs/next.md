# Nuvigator Next API

Nuvigator is passing through a major revamp in it's API, to be able to provide a more dynamic and easy to use experience. The core functional features of Nuvigator are going to be kept, and improved, but the development API is going to change drastically. Right now both APIs (current and next) can coexist, but it's preferred to use the NEXT API when developing new flows.

## Quick Start

```dart
import 'package:nuvigator/next.dart'; // import the next file instead of the nuvigator.dart

// Define a new NuRoute
class MyRoute extends NuRoute {
  
  String get path => 'my-route';
  
  ScreenType get screenType => materialScreenType;
  
  Widget build(BuildContext context, NuRouteSettings settings) {
    return MyScreen();
  }
}

// Define your NuModule
class MyModule extends NuModule {
  
}

```

## Defining Routes

Routes represent a reachable screen in your application, routes are represented by the `NuRoute` class. Each `NuRoute` should at least provide it's full path, and a build method. There are other optional properties that can specified in a `NuRoute`.

### NuRoute

To create your Route, you should extend the `NuRoute` class and implement (at least) the required overrides.

Example:

```dart
```

Inside your `NuRoute` class you will have access to the the `NuModule` and `Nuvigator` that is presenting it.

### NuRouteBuilder

You can define inline Routes using a `NuRouteBuilder` this approach is usually better suited for smaller flows or Routes that do not require any kind of initialization process.

Example:

```dart
```

## Modules

Modules are a grouping of `NuRoute`s, there are provided to the Nuvigator as it's controller. `NuModules` can implement custom initialization functions and configure itself correctly before the `Nuvigator` is presented. 

### NuModule

### NuModuleBuilder


## Nuvigator

### DeepLink First

- Using the `.open` method.

### Nuvigator.module

Helper factory to create a `Nuvigator` from a `NuModule`.

### Nuvigator.routes

Helper factory to create `Nuvigator` from a List of `NuRoute`s.
