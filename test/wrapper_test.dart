import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures/test_router.dart';
import 'helpers.dart' as helpers;

void main() {
  testWidgets(
      'Routes should to wraps with screensWrapper Widget of parent router',
      (WidgetTester tester) async {
    final router = TestRouter();
    await helpers.pumpApp(tester, router, TestRoutes.home);

    final widgetFinder = find.byKey(const Key(TestRoutes.home));
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets(
      'Routes should to wraps with screensWrapper Widget of Router and ScreenRoute ',
      (WidgetTester tester) async {
    final router = TestRouter();
    await helpers.pumpApp(tester, router, TestRoutes.home);

    router.openDeepLink<void>('exapp://testargs');
    await tester.pumpAndSettle();

    final widgetFinder = find.byKey(const Key(TestRoutes.testArgs));

    expect(widgetFinder, findsNWidgets(2));
  });
}
