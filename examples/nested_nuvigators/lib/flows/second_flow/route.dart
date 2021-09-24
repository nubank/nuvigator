import 'package:flutter/material.dart';
import 'screens/display_screen.dart';
import 'screens/input_screen.dart';
import 'package:nuvigator/next.dart';

class _SecondFlowRouter extends NuRouter {
  @override
  String get initialRoute => 'second-flow/screen1';

  @override
  ScreenType get screenType => materialScreenType;

  @override
  List<NuRoute> get registerRoutes => [
        NuRouteBuilder(
          path: 'second-flow/screen1',
          builder: (_, __, ___) => InputScreen(
            onNext: (text) => nuvigator.open(
              'second-flow/screen2',
              parameters: {'text': text},
            ),
          ),
        ),
        NuRouteBuilder(
          path: 'second-flow/screen2',
          builder: (_, __, settings) => DisplayScreen(
            text: settings.rawParameters['text'],
            onClose: () => nuvigator.closeFlow(),
          ),
        ),
      ];
}

class SecondFlowRoute extends NuRoute {
  @override
  String get path => 'second-flow';

  @override
  ScreenType get screenType => cupertinoDialogScreenType;

  @override
  Widget build(BuildContext context, NuRouteSettings<Object> settings) {
    return Nuvigator(
      router: _SecondFlowRouter(),
    );
  }
}
