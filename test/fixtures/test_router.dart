import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';

part 'test_router.g.dart';

@NuRouter()
class TestRouter extends Router {
  @NuRoute(deepLink: 'home')
  ScreenRoute<void> home() => ScreenRoute(
        builder: (context) => const Text('Home'),
      );

  @NuRoute(deepLink: 'testargs')
  ScreenRoute<void> testArgs({
    int intArg,
    double doubleArg,
    bool boolArg,
    DateTime dateTimeArg,
    DateTime dateArg,
    String stringArg,
  }) =>
      ScreenRoute(
        builder: (context) => Column(
          children: [
            Text('intArg: $intArg'),
            Text('doubleArg: $doubleArg'),
            Text('boolArg: $boolArg'),
            Text('dateTimeArg: $dateTimeArg'),
            Text('dateArg: $dateArg'),
            Text('stringArg: $stringArg'),
          ],
        ),
      );

  @override
  Map<RouteDef, ScreenRouteBuilder> get screensMap => _$screensMap;
}
