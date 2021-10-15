import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuvigator/next.dart';
import 'package:pedantic/pedantic.dart';

Widget baseNuvigator(Key key, Key nestedKey) {
  return MaterialApp(
    title: 'Test Nuvigator',
    builder: Nuvigator.routes(
      initialRoute: 'screen1',
      key: key,
      screenType: materialScreenType,
      routes: [
        NuRouteBuilder(
          path: 'screen1',
          builder: (_, __, ___) => const Text('Screen1'),
        ),
        NuRouteBuilder(
          path: 'screen2',
          builder: (_, __, ___) => const Text('Screen2'),
        ),
        NuRouteBuilder(
          path: 'screen3',
          builder: (_, __, ___) {
            return Nuvigator.routes(
              initialRoute: 'nestedScreen1',
              key: nestedKey,
              screenType: materialScreenType,
              routes: [
                NuRouteBuilder(
                    path: 'nestedScreen1',
                    builder: (_, __, ___) => const Text('NestedScreen1')),
                NuRouteBuilder(
                    path: 'nestedScreen2',
                    builder: (_, __, ___) => const Text('NestedScreen2')),
                NuRouteBuilder(
                    path: 'nestedScreen3',
                    builder: (_, __, ___) => const Text('NestedScreen3')),
              ],
            );
          },
        ),
        NuRouteBuilder(
          path: 'screen4',
          builder: (_, __, ___) => const Text('Screen4'),
        ),
      ],
    ),
  );
}

class NuvigatorStateTracker {
  NuvigatorStateTracker({this.rootKey, this.nestedKey});
  final GlobalKey<NuvigatorState<INuRouter>> rootKey;
  final GlobalKey<NuvigatorState<INuRouter>> nestedKey;

  NuvigatorState get rootNuvigator => rootKey.currentState;
  NuvigatorState get nestedNuvigator => nestedKey.currentState;
  List<Route> get rootStack => rootNuvigator.stateTracker.stack;
  List<Route> get nestedStack => nestedNuvigator.stateTracker.stack;
}

Future<NuvigatorStateTracker> pumpApp(
  WidgetTester tester,
) async {
  // ignore: omit_local_variable_types
  final GlobalKey<NuvigatorState<INuRouter>> nuvigatorKey =
      GlobalKey(debugLabel: 'NUVIGATOR_TESTER');
  // ignore: omit_local_variable_types
  final GlobalKey<NuvigatorState<INuRouter>> nestedNuvigatorKey =
      GlobalKey(debugLabel: 'NUVIGATOR_TESTER');
  await tester.pumpWidget(baseNuvigator(nuvigatorKey, nestedNuvigatorKey));
  await tester.pumpAndSettle();
  return NuvigatorStateTracker(
    rootKey: nuvigatorKey,
    nestedKey: nestedNuvigatorKey,
  );
}

void expectScreen(String screenName) {
  expect(find.text(screenName), findsOneWidget);
}

void main() {
  testWidgets('open initial screen', (tester) async {
    await pumpApp(tester);
    // Opens Initial Screen
    expect(find.text('Screen1'), findsOneWidget);
  });

  testWidgets('Nuvigator.pushNamed', (tester) async {
    final nuvigatorTracker = await pumpApp(tester);
    // Opens Initial Screen
    expect(find.text('Screen1'), findsOneWidget);
    // Go to Screen2
    unawaited(nuvigatorTracker.rootNuvigator.pushNamed('screen2'));
    await tester.pumpAndSettle();
    expect(find.text('Screen2'), findsOneWidget);

    // Go to Screen3
    unawaited(nuvigatorTracker.rootNuvigator.pushNamed('screen3'));
    await tester.pumpAndSettle();
    expect(find.text('NestedScreen1'), findsOneWidget);

    // Root Nuvigator Stack
    expect(nuvigatorTracker.rootNuvigator.stateTracker.stack.length, 3);
    // Nested Nuvigator Stack
    expect(nuvigatorTracker.nestedNuvigator.stateTracker.stack.length, 1);

    // Nested Navigation
    unawaited(nuvigatorTracker.nestedNuvigator.pushNamed('nestedScreen2'));
    await tester.pumpAndSettle();
    expectScreen('NestedScreen2');

    // Nested Navigation Propagate to Root
    unawaited(nuvigatorTracker.nestedNuvigator.pushNamed('screen4'));
    await tester.pumpAndSettle();
    expectScreen('Screen4');

    // Trying to pushNamed non-existed deepLink
    try {
      await nuvigatorTracker.nestedNuvigator.pushNamed('not-found');
    } catch (e) {
      expect(
        e is FlutterError &&
            e.message ==
                "DeepLink `not-found` was not found, and no `onDeepLinkNotFound` was specified in the Instance of 'NuRouterBuilder'.",
        true,
      );
    }
  });

  testWidgets('Nuvigator.pushReplacementNamed', (tester) async {
    final nuvigatorTracker = await pumpApp(tester);

    final resultScreen2 =
        nuvigatorTracker.rootNuvigator.pushReplacementNamed('screen2');
    await tester.pumpAndSettle();
    // New Route is on top
    expectScreen('Screen2');
    // Replaced the first Route, so we have just one in the stack
    expect(nuvigatorTracker.rootStack.length, 1);

    // Opening the Nested Flow
    final resultScreen3 = nuvigatorTracker.rootNuvigator.pushReplacementNamed(
      'screen3',
      result: 'return',
    );
    await tester.pumpAndSettle();
    expect(nuvigatorTracker.rootStack.length, 1);
    expect(nuvigatorTracker.nestedStack.length, 1);
    // Result was provided to the replaced screen Future
    expect(await resultScreen2, 'return');
    expectScreen('NestedScreen1');

    // Replace a nested screen
    unawaited(
      nuvigatorTracker.nestedNuvigator.pushReplacementNamed('nestedScreen2'),
    );
    await tester.pumpAndSettle();
    expectScreen('NestedScreen2');
    expect(nuvigatorTracker.nestedStack.length, 1);

    // Replace the whole Flow from a nested Nuvigator
    unawaited(nuvigatorTracker.nestedNuvigator.pushReplacementNamed(
      'screen4',
      result: 'return2',
    ));
    await tester.pumpAndSettle();
    expectScreen('Screen4');
    expect(await resultScreen3, 'return2');
    expect(nuvigatorTracker.rootStack.length, 1);
  });

  testWidgets('Nuvigator.pushNamedAndRemoveUntil', (tester) async {
    final tracker = await pumpApp(tester);
    // Will remove no screen and push screen2
    unawaited(tracker.rootNuvigator.pushNamedAndRemoveUntil(
      'screen2',
      (route) => true,
    ));
    await tester.pumpAndSettle();
    expectScreen('Screen2');
    expect(tracker.rootStack.length, 2);

    // Push Screen3 and remove all other screens
    unawaited(tracker.rootNuvigator.pushNamedAndRemoveUntil(
      'screen3',
      (route) => false,
    ));
    await tester.pumpAndSettle();
    expectScreen('NestedScreen1');
    expect(tracker.rootStack.length, 1);

    // Push Nested
    unawaited(tracker.nestedNuvigator.pushNamedAndRemoveUntil(
      'nestedScreen2',
      (route) => true,
    ));
    await tester.pumpAndSettle();
    expectScreen('NestedScreen2');
    expect(tracker.nestedStack.length, 2);

    // Push and remove until NestedScreen1
    unawaited(
      tracker.nestedNuvigator.pushNamedAndRemoveUntil(
        'nestedScreen3',
        NuRoute.withPath('nestedScreen1'),
      ),
    );
    await tester.pumpAndSettle();
    expectScreen('NestedScreen3');
    expect(tracker.nestedStack.length, 2);

    // Propagate to Root
    unawaited(
      tracker.nestedNuvigator.pushNamedAndRemoveUntil(
        'screen4',
        (route) => false,
      ),
    );
    await tester.pumpAndSettle();
    expectScreen('Screen4');
    expect(tracker.rootStack.length, 1);
  });

  testWidgets('Nuvigator.popAndPushNamed', (tester) async {
    final tracker = await pumpApp(tester);

    final resultScreen2 = tracker.rootNuvigator.pushNamed('screen2');
    await tester.pumpAndSettle();

    unawaited(tracker.rootNuvigator.popAndPushNamed(
      'screen4',
      result: 'result1',
    ));
    await tester.pumpAndSettle();
    expectScreen('Screen4');
    expect(tracker.rootStack.length, 2);
    expect(await resultScreen2, 'result1');
  });

  testWidgets('Nuvigator.pop', (tester) async {
    final tracker = await pumpApp(tester);
    final screen2Result = tracker.rootNuvigator.pushNamed('screen2');
    await tester.pumpAndSettle();
    // Screen2 is pushed
    expectScreen('Screen2');

    tracker.rootNuvigator.pop('screen2Result');
    await tester.pumpAndSettle();

    // Screen2 is popped with success
    expectScreen('Screen1');
    expect(await screen2Result, 'screen2Result');
    expect(tracker.rootStack.length, 1);

    // Nested pop
    final screen3Result = tracker.rootNuvigator.pushNamed('screen3');
    await tester.pumpAndSettle();
    expectScreen('NestedScreen1');
    final nestedScreen2Result =
        tracker.nestedNuvigator.pushNamed('nestedScreen2');
    await tester.pumpAndSettle();
    expectScreen('NestedScreen2');
    tracker.nestedNuvigator.pop('nestedScreen2Result');
    await tester.pumpAndSettle();
    expect(await nestedScreen2Result, 'nestedScreen2Result');
    expectScreen('NestedScreen1');

    // Popping last screen of a nested Nuvigator
    tracker.nestedNuvigator.pop('screen3Result');
    await tester.pumpAndSettle();
    expectScreen('Screen1');
    expect(await screen3Result, 'screen3Result');
  });

  testWidgets('Nuvigator.closeFlow', (tester) async {
    final tracker = await pumpApp(tester);
    final nestedReturn = tracker.rootNuvigator.pushNamed('screen3');
    await tester.pumpAndSettle();
    expectScreen('NestedScreen1');

    unawaited(tracker.nestedNuvigator.pushNamed('nestedScreen2'));
    await tester.pumpAndSettle();
    expectScreen('NestedScreen2');

    tracker.nestedNuvigator.closeFlow('nestedReturn');
    await tester.pumpAndSettle();
    expectScreen('Screen1');
    expect(await nestedReturn, 'nestedReturn');
  });

  testWidgets('Nuvigator.replaceNamed', (tester) async {
    final tracker = await pumpApp(tester);

    unawaited(tracker.rootNuvigator.pushNamed('screen2'));
    await tester.pumpAndSettle();
    expectScreen('Screen2');

    // ReplaceNamed on the RootNuvigator
    tracker.rootNuvigator.replaceNamed(
      oldDeepLink: 'screen1',
      newDeepLink: 'screen4',
    );
    await tester.pumpAndSettle();
    expectScreen('Screen2');
    expect(tracker.rootStack.length, 2);
    // Route Below was Replaced
    tracker.rootNuvigator.pop();
    await tester.pumpAndSettle();
    expect(tracker.rootStack.length, 1);
    expectScreen('Screen4');

    // start region: Setup Nested Flow
    unawaited(tracker.rootNuvigator.pushNamed('screen3'));
    await tester.pumpAndSettle();
    unawaited(tracker.nestedNuvigator.pushNamed('nestedScreen2'));
    await tester.pumpAndSettle();
    expectScreen('NestedScreen2');
    // end region

    // start region: replace first route of the nested flow
    tracker.nestedNuvigator.replaceNamed(
      oldDeepLink: 'nestedScreen1',
      newDeepLink: 'nestedScreen3',
    );
    await tester.pumpAndSettle();
    tracker.nestedNuvigator.pop();
    await tester.pumpAndSettle();
    expectScreen('NestedScreen3');
    expect(tracker.nestedStack.length, 1);
    // end region

    // start region: propagate the replace to root nuvigator
    tracker.nestedNuvigator.replaceNamed(
      oldDeepLink: 'screen4',
      newDeepLink: 'screen2',
    );
    await tester.pumpAndSettle();
    tracker.nestedNuvigator.closeFlow();
    await tester.pumpAndSettle();
    expectScreen('Screen2');
    expect(tracker.rootStack.length, 1);
    // end region
  });

  testWidgets('Nuvigator.removeByPredicate', (tester) async {
    final tracker = await pumpApp(tester);
    unawaited(tracker.rootNuvigator.pushNamed('screen2'));
    await tester.pumpAndSettle();
    // start region: remove in the root Nuvigator
    tracker.rootNuvigator.removeByPredicate(NuRoute.withPath('screen1'));
    await tester.pumpAndSettle();
    expect(tracker.rootStack.length, 1);
    expect(tracker.rootStack.first.settings.name, 'screen2');
    // end region

    // start region: removing from the nested Nuvigator
    unawaited(tracker.rootNuvigator.pushNamed('screen3'));
    await tester.pumpAndSettle();
    unawaited(tracker.nestedNuvigator.pushNamed('nestedScreen2'));
    await tester.pumpAndSettle();
    tracker.nestedNuvigator
        .removeByPredicate(NuRoute.withPath('nestedScreen1'));
    await tester.pumpAndSettle();
    expect(tracker.nestedStack.length, 1);
    expect(tracker.nestedStack.first.settings.name, 'nestedScreen2');
    // end region

    // start region: propagate to root Nuvigator
    expect(tracker.rootStack.length, 2);
    tracker.nestedNuvigator.removeByPredicate(NuRoute.withPath('screen2'));
    await tester.pumpAndSettle();
    expect(tracker.rootStack.length, 1);
    expect(tracker.rootStack.first.settings.name, 'screen3');
    // end region
  });

  testWidgets('Nuvigator.open', (tester) async {
    final tracker = await pumpApp(tester);
    // start region: default push method
    unawaited(tracker.rootNuvigator.open('screen2'));
    await tester.pumpAndSettle();
    expectScreen('Screen2');
    expect(tracker.rootStack.length, 2);
    expect(
      tracker.rootStack.map((e) => e.settings.name),
      ['screen1', 'screen2'],
    );
    // end region

    // start region: pushReplacement push method
    final screen4Result = tracker.rootNuvigator.open(
      'screen4',
      pushMethod: DeepLinkPushMethod.PushReplacement,
    );
    await tester.pumpAndSettle();
    expectScreen('Screen4');
    expect(tracker.rootStack.length, 2);
    expect(
      tracker.rootStack.map((e) => e.settings.name),
      ['screen1', 'screen4'],
    );
    // end region

    // start region: popAndPush push method
    unawaited(tracker.rootNuvigator.open(
      'screen2',
      pushMethod: DeepLinkPushMethod.PopAndPush,
      result: 'screen4Result',
    ));
    await tester.pumpAndSettle();
    expect(await screen4Result, 'screen4Result');
    expectScreen('Screen2');
    expect(tracker.rootStack.length, 2);
    expect(
      tracker.rootStack.map((e) => e.settings.name),
      ['screen1', 'screen2'],
    );
    // end region
  });

  testWidgets('nested Nuvigator.open', (tester) async {
    final tracker = await pumpApp(tester);
    // start region: nested propagation
    // setup
    final screen3Result = tracker.rootNuvigator.open('screen3');
    await tester.pumpAndSettle();
    expect(
      tracker.rootStack.map((e) => e.settings.name),
      ['screen1', 'screen3'],
    );
    // open nested screen
    unawaited(tracker.nestedNuvigator.open('nestedScreen2'));
    await tester.pumpAndSettle();
    expectScreen('NestedScreen2');
    expect(
      tracker.nestedStack.map((e) => e.settings.name),
      ['nestedScreen1', 'nestedScreen2'],
    );
    // open root screen from nested Nuvigator
    unawaited(tracker.nestedNuvigator.open('screen4'));
    await tester.pumpAndSettle();
    expectScreen('Screen4');
    expect(
      tracker.rootStack.map((e) => e.settings.name),
      ['screen1', 'screen3', 'screen4'],
    );
    // back to nested flow
    tracker.rootNuvigator.pop();
    await tester.pumpAndSettle();
    expectScreen('NestedScreen2');
    expect(
      tracker.rootStack.map((e) => e.settings.name),
      ['screen1', 'screen3'],
    );

    unawaited(tracker.nestedNuvigator.open(
      'screen4',
      pushMethod: DeepLinkPushMethod.PopAndPush,
      result: 'screen3Result',
    ));
    await tester.pumpAndSettle();
    expectScreen('Screen4');
    expect(await screen3Result, 'screen3Result');
    expect(
      tracker.rootStack.map((e) => e.settings.name),
      ['screen1', 'screen4'],
    );

    unawaited(tracker.rootNuvigator.open(
      'screen3',
      pushMethod: DeepLinkPushMethod.PushReplacement,
    ));
    await tester.pumpAndSettle();
    expect(
      tracker.rootStack.map((e) => e.settings.name),
      ['screen1', 'screen3'],
    );
    unawaited(tracker.nestedNuvigator.open(
      'screen2',
      pushMethod: DeepLinkPushMethod.PushReplacement,
    ));
    await tester.pumpAndSettle();
    expectScreen('Screen2');
    expect(
      tracker.rootStack.map((e) => e.settings.name),
      ['screen1', 'screen2'],
    );
    // end region
  });
}
