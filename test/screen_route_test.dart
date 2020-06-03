import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuvigator/nuvigator.dart';

void main() {
  test('RoutePath equality', () {
    final routeDef1 = RoutePath('route1');
    final routeDef2 = RoutePath('route2');
    final routeDef3 = RoutePath('route1', prefix: true);

    final routeMap = {
      routeDef1: 1,
      routeDef2: 2,
      routeDef3: 3,
    };

    expect(routeDef1 == routeDef2, false);
    expect(routeDef1 == routeDef3, false);
    expect(routeMap[routeDef1], 1);
    expect(routeMap[routeDef2], 2);
    expect(routeMap[routeDef3], 3);
  });

  test('ScreenRoute toRoute return a valid Route given the screenType', () {
    final screenRoute = ScreenRoute(
      builder: (_) => null,
      screenType: materialScreenType,
    );
    final route = screenRoute.toRoute(const NuRouteSettings(
      routePath: null,
      name: null,
    ));
    expect(route is MaterialPageRoute, true);
  });

  test('Adding fallback screenType to ScreenRoute', () {
    final screenRoute = ScreenRoute(
      builder: (_) => null,
    ).fallbackScreenType(materialScreenType);
    final route = screenRoute.toRoute(const NuRouteSettings(
      routePath: null,
      name: null,
    ));
    expect(route is MaterialPageRoute, true);
  });

  test('ScreenRoute wrapWith, with null', () {
    final screenRoute = ScreenRoute(
      builder: (_) => null,
    );
    expect(screenRoute.wrapWith(null), screenRoute);
  });
}
