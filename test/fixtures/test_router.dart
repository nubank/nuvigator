import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';

part 'test_router.g.dart';

@nuRouter
class TestRouter extends NuRouter {
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
        wrapper: (BuildContext context, Widget child) {
          final settings = ModalRoute.of(context).settings;
          final routeName = settings.name;
          return Container(
            key: Key(routeName),
            child: child,
          );
        },
      );

  @override
  Map<RoutePath, ScreenRouteBuilder> get screensMap => _$screensMap;

  @override
  WrapperFn get screensWrapper => (BuildContext context, Widget child) {
        final settings = ModalRoute.of(context).settings;
        final routeName = settings.name;
        return Container(
          key: Key(routeName),
          child: child,
        );
      };
}
