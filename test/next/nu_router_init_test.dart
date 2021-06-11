import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuvigator/next.dart';

import 'fixtures/test_next_router.dart';

void main() {
  Future<void> pumpFakeApp({
    @required WidgetTester tester,
    @required NuRouter router,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Nuvigator(router: router),
      ),
    );
    await tester.pumpAndSettle();
  }

  void expectOnError(Object error, dynamic matcher) {
    expect(find.text(error.runtimeType.toString()), matcher);
  }

  void expectSuccess(dynamic matcher) {
    expect(find.text(InitTestNextRouter.successText), matcher);
  }

  group(
    'When starting a next router that awaits for init',
    () {
      testWidgets(
        'with success, should display success widget',
        (tester) async {
          final router = InitTestNextRouter(
            routerInitFuture: () => Future.value(),
            routeInitFuture: () => Future.value(true),
          );

          await pumpFakeApp(tester: tester, router: router);
          expectSuccess(findsOneWidget);
        },
      );

      testWidgets(
        'with an exception on router init, should display the error widget',
        (tester) async {
          final exception = Exception();
          final router = InitTestNextRouter(
            routerInitFuture: () => Future.error(exception),
            routeInitFuture: () => Future.value(true),
          );

          await pumpFakeApp(tester: tester, router: router);

          expectOnError(exception, findsOneWidget);
        },
      );

      testWidgets(
        'with an error on router init, should display the error widget',
        (tester) async {
          final error = Error();
          final router = InitTestNextRouter(
            routerInitFuture: () => Future.error(error),
            routeInitFuture: () => Future.value(true),
          );

          await pumpFakeApp(tester: tester, router: router);

          expectOnError(error, findsOneWidget);
        },
      );

      testWidgets(
        'with an exception on route init, should display the error widget',
        (tester) async {
          final exception = Exception();
          final router = InitTestNextRouter(
            routerInitFuture: () => Future.value(),
            routeInitFuture: () => Future.error(exception),
          );

          await pumpFakeApp(tester: tester, router: router);

          expectOnError(exception, findsOneWidget);
        },
      );

      testWidgets(
        'with an error on route init, should display the error widget',
        (tester) async {
          final error = Error();
          final router = InitTestNextRouter(
            routerInitFuture: () => Future.value(),
            routeInitFuture: () => Future.error(error),
          );

          await pumpFakeApp(tester: tester, router: router);

          expectOnError(error, findsOneWidget);
        },
      );
    },
  );
}
