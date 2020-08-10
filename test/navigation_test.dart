import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuvigator/nuvigator.dart';
import 'fixtures/test_router.dart';

void main() {
  Future pumpApp(
      WidgetTester tester, Router router, String initialRoute) async {
    await tester.pumpWidget(MaterialApp(
      title: 'Test Nuvigator',
      builder: Nuvigator(
        screenType: cupertinoDialogScreenType,
        router: router,
        initialRoute: initialRoute,
      ),
    ));
  }

  testWidgets('Navigates to deepLink without args',
      (WidgetTester tester) async {
    final router = TestRouter();
    await pumpApp(tester, router, TestRoutes.home);
    router.openDeepLink<void>(Uri.parse('exapp://testargs'));
    await tester.pumpAndSettle();
    expect(find.text('intArg: null'), findsOneWidget);
  });

  testWidgets('Navigates to deepLink with typed args',
      (WidgetTester tester) async {
    final router = TestRouter();
    await pumpApp(tester, router, TestRoutes.home);
    router.openDeepLink<void>(Uri.parse(
        'exapp://testargs?intArg=42&doubleArg=-4.2&boolArg=true&dateTimeArg=2020-07-07T12:34:00.000Z&dateArg=2020-08-07&stringArg=testing'));
    await tester.pumpAndSettle();
    expect(find.text('intArg: 42'), findsOneWidget);
    expect(find.text('doubleArg: -4.2'), findsOneWidget);
    expect(find.text('boolArg: true'), findsOneWidget);
    expect(find.text('dateTimeArg: 2020-07-07 12:34:00.000Z'), findsOneWidget);
    expect(find.text('dateArg: 2020-08-07 00:00:00.000'), findsOneWidget);
    expect(find.text('stringArg: testing'), findsOneWidget);
  });
}
