import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuvigator/next.dart';

class TestNextRouter extends NuRouter {
  TestNextRouter({
    this.initRoute = 'success',
    this.extraRoutes,
  });

  static const successText = 'Success';

  final String initRoute;
  final List<NuRoute<NuRouter, Object?, Object>>? extraRoutes;

  @override
  String get initialRoute => initRoute;

  @override
  bool get awaitForInit => true;

  @override
  ScreenType get screenType => const MaterialScreenType();

  @override
  Widget onError(Object error, NuRouterController controller) {
    return Text(error.runtimeType.toString());
  }

  @override
  List<NuRoute<NuRouter, Object?, Object>> get registerRoutes => [
        NuRouteBuilder(
          builder: (context, route, settings) => const Text(successText),
          path: 'success',
        ),
        ...?extraRoutes,
      ];
}

void main() {
  Future<void> pumpFakeApp({
    Key? nuvigatorKey,
    required WidgetTester tester,
    required NuRouter? router,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Nuvigator(
          key: nuvigatorKey,
          router: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('when building an app with a nested Nuvigator', () {
    GlobalKey<NuvigatorState>? rootNuvigatorKey;
    GlobalKey<NuvigatorState>? nestedNuvigatorKey;
    NuRouter? routerUnderTest;

    setUp(() {
      rootNuvigatorKey = GlobalKey<NuvigatorState>();
      nestedNuvigatorKey = GlobalKey<NuvigatorState>();
      routerUnderTest = TestNextRouter(
        initRoute: 'nested',
        extraRoutes: [
          NuRouteBuilder(
            path: 'parent',
            builder: (context, __, ___) => const Text('Parent route'),
          ),
          NuRouteBuilder(
            path: 'nested',
            builder: (context, __, ___) => Nuvigator(
              key: nestedNuvigatorKey,
              router: TestNextRouter(
                extraRoutes: [
                  NuRouteBuilder(
                    path: 'second',
                    builder: (_, __, ___) => const Text('Second nested route'),
                  )
                ],
              ),
            ),
          ),
        ],
      );
    });

    testWidgets('it opens deeplink in the same level', (tester) async {
      await pumpFakeApp(
        nuvigatorKey: rootNuvigatorKey,
        tester: tester,
        router: routerUnderTest,
      );

      // ignore: unawaited_futures
      nestedNuvigatorKey!.currentState!.open(
        'second',
        pushMethod: DeepLinkPushMethod.PushReplacement,
        isFromNative: false,
        parameters: <String, dynamic>{'test': 1},
      );

      await tester.pumpAndSettle();

      expect(find.text('Second nested route'), findsOneWidget);
      expect(
        nestedNuvigatorKey!.currentState!.stateTracker!.stackRouteNames,
        equals(['second']),
      );
      expect(
        rootNuvigatorKey!.currentState!.stateTracker!.stackRouteNames,
        equals(['nested']),
      );
    });

    testWidgets('it opens deeplink using parent Nuvigator', (tester) async {
      await pumpFakeApp(
        nuvigatorKey: rootNuvigatorKey,
        tester: tester,
        router: routerUnderTest,
      );

      // ignore: unawaited_futures
      nestedNuvigatorKey!.currentState!.open(
        'parent',
        pushMethod: DeepLinkPushMethod.PushReplacement,
        isFromNative: false,
        parameters: <String, dynamic>{'test': 1},
      );

      await tester.pumpAndSettle();

      expect(find.text('Parent route'), findsOneWidget);
      expect(
        nestedNuvigatorKey!.currentState,
        isNull,
      );
      expect(
        rootNuvigatorKey!.currentState!.stateTracker!.stackRouteNames,
        equals(['parent']),
      );
    });
  });
}
