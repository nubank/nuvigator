import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuvigator/nuvigator.dart';

void main() {
  test('RouteDef equality is based in the routeName', () {
    final routeDef1 = RouteDef('route1', deepLink: 'deepLink1');
    final routeDef2 = RouteDef('route2', deepLink: 'deepLink2');
    final routeDef3 = RouteDef('route1', deepLink: 'deepLink3');

    final routeMap = {
      routeDef1: 1,
      routeDef2: 2,
      routeDef3: 3,
    };

    expect(routeDef1 == routeDef2, false);
    expect(routeDef1 == routeDef3, true);
    expect(routeMap[routeDef1], 3); // routeDef3 override
    expect(routeMap[routeDef2], 2);
    expect(routeMap[routeDef3], 3);
  });

  test('ScreenRoute toRoute return a valid Route given the screenType', () {
    final screenRoute = ScreenRoute(
      builder: (_) => null,
      screenType: materialScreenType,
    );
    final route = screenRoute.toRoute(const RouteSettings());
    expect(route is MaterialPageRoute, true);
  });

  test('Adding fallback screenType to ScreenRoute', () {
    final screenRoute = ScreenRoute(
      builder: (_) => null,
    ).fallbackScreenType(materialScreenType);
    final route = screenRoute.toRoute(const RouteSettings());
    expect(route is MaterialPageRoute, true);
  });

  test('ScreenRoute wrapWith, with null', () {
    final screenRoute = ScreenRoute(
      builder: (_) => null,
    );
    expect(screenRoute.wrapWith(null), screenRoute);
  });
}
