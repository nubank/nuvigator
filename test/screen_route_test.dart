import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuvigator/nuvigator.dart';

void main() {
  test('ScreenRoute toRoute return a valid Route given the screenType', () {
    final screenRoute = ScreenRoute(
      builder: (_) => Container(),
      screenType: materialScreenType,
      nuRouteSettings:
          const NuRouteSettings(name: 'a', pathTemplate: 'a', scheme: ''),
    );
    final route = screenRoute.toRoute(const RouteSettings());
    expect(route is MaterialPageRoute, true);
  });

  test('Adding fallback screenType to ScreenRoute', () {
    final screenRoute = ScreenRoute(
      builder: (_) => Container(),
      nuRouteSettings:
          const NuRouteSettings(name: 'a', pathTemplate: 'a', scheme: ''),
    ).fallbackScreenType(materialScreenType);
    final route = screenRoute.toRoute(const RouteSettings());
    expect(route is MaterialPageRoute, true);
  });

  test('ScreenRoute wrapWith, with null', () {
    final screenRoute = ScreenRoute(
      builder: (_) => Container(),
      nuRouteSettings:
          const NuRouteSettings(name: 'a', pathTemplate: 'a', scheme: ''),
    );
    expect(screenRoute.wrapWith(null), screenRoute);
  });
}
