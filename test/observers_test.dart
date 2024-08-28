import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nuvigator/next.dart';

class MockFakeLog extends Mock implements FakeLog {}

void main() {
  Future<void> _navigateToNextPage(WidgetTester tester, String key) async {
    await tester.tap(find.byKey(Key(key)));
    await tester.pumpAndSettle();
  }

  Future<void> _popCurrentPage(WidgetTester tester, String key) async {
    await tester.tap(find.byKey(Key(key)));
    await tester.pumpAndSettle();
  }

  testWidgets('pop event must called twice', (WidgetTester tester) async {
    final mockFakeLog = MockFakeLog();
    await tester.pumpWidget(MyApp(fakeLog: mockFakeLog));
    await tester.pumpAndSettle();

    await _navigateToNextPage(tester, 'second');
    await _navigateToNextPage(tester, 'nested');
    await _navigateToNextPage(tester, 'nested_second');
    await _popCurrentPage(tester, 'nested_home-pop');

    verify(mockFakeLog.sayPop()).called(2);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({this.fakeLog});
  final FakeLog fakeLog;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nuvigator App',
      builder: Nuvigator.routes(
        initialRoute: 'home',
        screenType: materialScreenType,
        routes: _buildRoutes(),
        observers: [_createObserver()],
        inheritableObservers: [_createInheritableObserver()],
      ),
    );
  }

  List<NuRouteBuilder> _buildRoutes() {
    return [
      NuRouteBuilder(
        path: 'home',
        builder: (_, __, ___) =>
            DummyPage(pageName: 'home', nextRoute: 'second'),
      ),
      NuRouteBuilder(
        path: 'second',
        builder: (_, __, ___) =>
            DummyPage(pageName: 'second', nextRoute: 'nested'),
      ),
      NuRouteBuilder(
        path: 'nested',
        builder: (_, __, ___) => Nuvigator.routes(
          initialRoute: 'nested_home',
          screenType: materialScreenType,
          routes: [
            NuRouteBuilder(
              path: 'nested_home',
              builder: (_, __, ___) => DummyPage(
                  pageName: 'nested_home', nextRoute: 'nested_second'),
            ),
            NuRouteBuilder(
              path: 'nested_second',
              builder: (_, __, ___) => DummyPage(
                  pageName: 'nested_second', nextRoute: 'nested_home'),
            ),
          ],
        ),
      ),
    ];
  }

  DummyObservable _createObserver() => DummyObservable(fakeLog: fakeLog);

  DummyObservable Function() _createInheritableObserver() =>
      () => DummyObservable(fakeLog: fakeLog);
}

abstract class FakeLog {
  void sayPop() => print('Hi, I say pop');
  void sayPush() => print('Hi, I say push');
  void sayReplace() => print('Hi, I say replace');
  void sayRemove() => print('Hi, I say remove');
}

class DummyObservable extends NavigatorObserver {
  DummyObservable({this.fakeLog});
  FakeLog fakeLog;

  @override
  void didPop(Route route, Route previousRoute) {
    fakeLog.sayPop();
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route previousRoute) {
    fakeLog.sayPush();
    super.didPush(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route previousRoute) {
    fakeLog.sayRemove();
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    fakeLog.sayReplace();
    //super.didReplace(newRoute, oldRoute);
  }
}

class DummyPage extends StatelessWidget {
  const DummyPage({this.pageName, this.nextRoute});
  final String pageName;
  final String nextRoute;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pageName)),
      body: Column(
        children: [
          _buildNextButton(context),
          _buildPopButton(context),
        ],
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return Center(
      child: IconButton(
        key: Key(nextRoute),
        icon: const Icon(Icons.navigate_next),
        onPressed: () => Nuvigator.of(context).open(nextRoute),
      ),
    );
  }

  Widget _buildPopButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        key: Key('$nextRoute-pop'),
        onPressed: () => Nuvigator.of(context).pop(),
        child: const Text('pop'),
      ),
    );
  }
}
