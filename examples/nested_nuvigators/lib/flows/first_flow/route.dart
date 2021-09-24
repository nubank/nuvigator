import 'package:flutter/material.dart';
import 'package:nested_nuvigators/flows/first_flow/screens/one_screen.dart';
import 'package:nested_nuvigators/flows/first_flow/screens/three_screen.dart';
import 'package:nested_nuvigators/flows/first_flow/screens/two_screen.dart';
import 'package:nuvigator/next.dart';

class _FirstFlowRouter extends NuRouter {
  @override
  String get initialRoute => 'first-flow/screen1';

  @override
  ScreenType get screenType => materialScreenType;

  @override
  List<NuRoute> get registerRoutes => [
        NuRouteBuilder(
          path: 'first-flow/screen1',
          builder: (_, __, ___) => OneScreen(
            onNext: () => nuvigator.open('first-flow/screen2'),
            onClose: () => nuvigator.closeFlow(),
          ),
        ),
        NuRouteBuilder(
          path: 'first-flow/screen2',
          builder: (_, __, ___) => TwoScreen(
            onNext: () => nuvigator.open('first-flow/screen3'),
            onClose: () => nuvigator.closeFlow(),
          ),
        ),
        NuRouteBuilder(
          path: 'first-flow/screen3',
          builder: (_, __, ___) => ThreeScreen(
            onNext: () => nuvigator.open('second-flow'),
            onClose: () => nuvigator.closeFlow(),
          ),
        ),
      ];
}

class FirstFlowRoute extends NuRoute {
  @override
  String get path => 'first-flow';

  @override
  ScreenType get screenType => cupertinoDialogScreenType;

  @override
  Widget build(BuildContext context, NuRouteSettings<Object> settings) {
    return Nuvigator(
      router: _FirstFlowRouter(),
    );
  }
}
