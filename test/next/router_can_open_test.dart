import 'package:flutter/material.dart';
import 'package:nuvigator/next.dart';
import 'package:flutter_test/flutter_test.dart';

class ExampleRouter extends NuRouter {
  @override
  String get initialRoute => 'example-route-a';

  @override
  List<NuRoute> get registerRoutes => [
        ExampleRouteA(),
        ExampleRouteB(),
        ExampleRouteC(),
      ];
}

class ExampleRouteA extends NuRoute {
  @override
  Widget build(BuildContext context, NuRouteSettings<Object> settings) {
    return Container();
  }

  @override
  String get path => 'example-route-a';

  @override
  ScreenType get screenType => cupertinoScreenType;
}

class ExampleRouteB extends NuRoute {
  @override
  Widget build(BuildContext context, NuRouteSettings<Object> settings) {
    return Container();
  }

  @override
  String get path => 'example-route-b';

  @override
  ScreenType get screenType => cupertinoScreenType;
}

class ExampleRouteC extends NuRoute {
  @override
  Widget build(BuildContext context, NuRouteSettings<Object> settings) {
    return Container();
  }

  @override
  String get path => 'example-route-c/:pathParameter';

  @override
  ScreenType get screenType => cupertinoScreenType;
}

void main() {
  final exampleRouter = ExampleRouter();

  group('Can open registerRoutes', () {
    test('Assert canOpen with basic deepLink', () {
      expect(exampleRouter.canOpen('example-route-a'), isTrue);
      expect(exampleRouter.canOpen('example-route-b'), isTrue);
      expect(exampleRouter.canOpen('example-route-aaa'), isFalse);
      expect(exampleRouter.canOpen('blablabla'), isFalse);
    });

    test('Assert canOpen with queryParameters', () {
      expect(exampleRouter.canOpen('example-route-a?foo=bar'), isTrue);
      expect(exampleRouter.canOpen('example-route-b?foo=bar'), isTrue);
    });

    test('Assert canOpen with pathParameters', () {
      expect(exampleRouter.canOpen('example-route-c/foo'), isTrue);
      expect(exampleRouter.canOpen('example-route-c/bar'), isTrue);
      expect(exampleRouter.canOpen('example-route-c/bar?foo=bar'), isTrue);
      expect(exampleRouter.canOpen('example-route-c'), isFalse);
    });
  });
}
