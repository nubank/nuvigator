import 'package:example/samples/modules/composer/screens/help_screen.dart';
import 'package:example/samples/modules/composer/screens/text_composer_screen.dart';
import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';

part 'composer_routes.g.dart';

@NuRouter()
class ComposerRouter extends Router {
  @override
  String get deepLinkPrefix => '/composer';

  @NuRoute(
    deepLink: '/text',
    pushMethods: [PushMethodType.push, PushMethodType.pushReplacement],
  )
  ScreenRoute<String> composeText({String initialText}) => ScreenRoute(
        builder: (context) => TextComposerScreen(
          initialText: initialText,
          submitText: (String text) => nuvigator.pop(text),
          toHelp: toHelp,
        ),
      );

  @NuRoute()
  ScreenRoute<void> help() => ScreenRoute(
        builder: (context) => HelpScreen(),
        screenType: cupertinoScreenType,
      );

  @override
  Map<RouteDef, ScreenRouteBuilder> get screensMap => _$screensMap;
}
