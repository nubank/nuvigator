# Getting Started

This guide will provide the simplest App using Nuvigator you can get. This is a good starting point for learning how to
setup the framework, and to incrementally learn more advanced features.

Given we have a simple Widget:

`lib/src/tutorial_screen.dart`
```dart
import 'paclage:flutter/widgets.dart';

class TutorialScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Text('Hello World!');
  }
}
```

1. Create your Router class, and declares a new Route:
    - Your Router should extends `BaseRouter` and be annotated with `@NuRouter`
    - Your Route should be a `ScreenRoute` and be annotated with `@NuRoute` 

`lib/src/router.dart`
```dart
import 'package:flutter/widgets.dart';
import 'package:nuvigator/nuvigator.dart';

part 'router.g.dart';

@NuRouter()
class TutorialRouter extends BaseRouter {

  @NuRoute()
  ScreenRoute tutorialRoute() => ScreenRoute(
    builder: (context) => TutorialScreen(screenContext),
  );

  @override
  Map<RouteDef, ScreenRouteBuilder> get screensMap  => _$tutorialScreensMap(this); // Will be generated
}
```

2. After creating this file, you can run Flutter build_runner:

```bash
$ flutter pub run build_runner build --delete-conflicting-outputs
```

The generated file will be `lib/src/router.g.dart` and will have several helper methods.

3. Main file:

`lib/src/main.dart`
```dart
import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';
import 'router.dart';

void main() {
  runApp(TutorialApp());
}

class TutorialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalRouter = GlobalRouter(baseRouter: TutorialRouter());
    return MaterialApp(
      builder: Nuvigator(
        initialRoute: TutorialRoutes.tutorialRoute,
        router: globalRouter,
      ),
    );
  }
}

```
