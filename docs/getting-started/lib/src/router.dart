import 'package:flutter/widgets.dart'; // Needed by the generated part-file
import 'package:nuvigator/nuvigator.dart';
import 'tutorial_screen.dart';

part 'router.g.dart';

@NuRouter()
class TutorialRouter extends BaseRouter {
  @NuRoute()
  ScreenRoute tutorialRoute() => ScreenRoute(
        builder: (_) => TutorialScreen(),
      );

  @override
  Map<RouteDef, ScreenRouteBuilder> get screensMap =>
      _$tutorialScreensMap(this); // Will be generated
}
