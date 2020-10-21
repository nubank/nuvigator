import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuvigator/nuvigator.dart';

import '../nurouter.dart';

const INITIAL_TEST_ROUTE = 'nuvigator://initialTestRoute';
const START_TEST_BUTTON_TEXT = '::NUVIGATOR::START_FLOW::';

class _DeepLink {
  // ignore: avoid_positional_boolean_parameters
  _DeepLink(this.url, this.arguments, this.isFromNative);

  final String url;
  final dynamic arguments;
  final bool isFromNative;
}

class TesterDeepLinkInterceptor {
  final List<_DeepLink> deepLinks = [];

  bool registerCallToDeepLink<T>(String url,
      [dynamic arguments, bool isFromNative = false]) {
    deepLinks.add(_DeepLink(url, arguments, isFromNative));
    return false;
  }

  void expectDeepLink(String url,
      {dynamic arguments, bool isFromNative = false}) {
    final deepLink = deepLinks.firstWhere((value) {
      return value.url == url;
    }, orElse: () => null);
    expect(deepLink, isNotNull, reason: 'Deeplink $url not found');
    expect(url, deepLink.url);
    expect(arguments, deepLink.arguments);
    expect(isFromNative, deepLink.isFromNative);
  }

  void unexpectDeepLink(String url,
      {dynamic arguments, bool isFromNative = false}) {
    final deepLink = deepLinks.firstWhere((value) {
      return value.url == url;
    }, orElse: () => null);
    expect(deepLink, isNull, reason: 'Deeplink $url found');
  }
}

class _EmptyWidget extends StatelessWidget {
  const _EmptyWidget(this.initialRoute, [this.arguments]) : super();

  final String initialRoute;
  final Object arguments;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: RaisedButton(
          onPressed: () {
            Nuvigator.of(context).pushNamed(
              initialRoute,
              arguments: arguments,
            );
          },
          child: const Text(START_TEST_BUTTON_TEXT),
        ),
      );
}

NuRouter makeTestRouter(NuRouter router, String initialRoute,
    [Object arguments]) {
  final nuvigatorInitialRouter = SingleRouteHandler(
    RoutePath(INITIAL_TEST_ROUTE),
    ScreenRoute(
      builder: (_) => _EmptyWidget(initialRoute, arguments),
    ),
  );
  return mergeRouters([router, nuvigatorInitialRouter]);
}

Nuvigator makeTestNuvigator(NuRouter router, String initialRoute,
    TesterDeepLinkInterceptor deepLinkInterceptor,
    [Object arguments]) {
  final appRouter = makeTestRouter(router, initialRoute);
  return Nuvigator(
    router: appRouter,
    deepLinkInterceptor: deepLinkInterceptor.registerCallToDeepLink,
    initialRoute: INITIAL_TEST_ROUTE,
  );
}

Future<void> withMockRouter({
  @required WidgetTester tester,
  @required NuRouter router,
  @required String initialRoute,
  Object arguments,
}) async {
  final app = MaterialApp(
    builder: (context, child) {
      return makeTestNuvigator(router, initialRoute, arguments);
    },
  );

  await tester.pumpWidget(app);
  await tester.pumpAndSettle();

  expect(find.byType(_EmptyWidget), findsOneWidget);

  await tester.tap(find.text(START_TEST_BUTTON_TEXT));
  await tester.pumpAndSettle();
}

class NuvigatorTester {
  NuvigatorTester(this.router, this.initialRoute, this.tester) {
    nuvigator = makeTestNuvigator(router, initialRoute, deepLinkInterceptor);
  }

  Nuvigator nuvigator;
  final NuRouter router;
  final WidgetTester tester;
  final String initialRoute;
  final TesterDeepLinkInterceptor deepLinkInterceptor =
      TesterDeepLinkInterceptor();

  Future<void> start() async {}
}
