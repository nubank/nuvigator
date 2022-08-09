import 'package:flutter/widgets.dart';
import 'package:nuvigator/next.dart';

class InitTestNextRouter extends NuRouter {
  InitTestNextRouter({
    required this.routerInitFuture,
    required this.routeInitFuture,
    this.buildWrapperFn,
  })  : assert(routerInitFuture != null),
        assert(routeInitFuture != null);

  static const initRoute = 'foo', successText = 'Success';

  final Future<void> Function() routerInitFuture;
  final Future<bool> Function() routeInitFuture;
  final Widget Function(
    BuildContext context,
    Widget child,
    NuRouteSettings settings,
    NuRoute nuRoute,
  )? buildWrapperFn;

  @override
  String get initialRoute => initRoute;

  @override
  bool get awaitForInit => true;

  @override
  ScreenType get screenType => const MaterialScreenType();

  @override
  Widget buildWrapper(
    BuildContext context,
    Widget child,
    NuRouteSettings settings,
    NuRoute nuRoute,
  ) =>
      buildWrapperFn == null
          ? child
          : buildWrapperFn!(
              context,
              child,
              settings,
              nuRoute,
            );

  @override
  Future<void> init(BuildContext context) => routerInitFuture();

  @override
  Widget onError(Object error, NuRouterController controller) {
    return Text(error.runtimeType.toString());
  }

  @override
  List<NuRoute<NuRouter, Object?, Object>> get registerRoutes => [
        NuRouteBuilder(
          builder: (context, route, settings) => const Text(successText),
          path: initialRoute,
          initializer: (context) => routeInitFuture(),
        ),
      ];
}

class FakeWrapper extends StatelessWidget {
  const FakeWrapper(Key key, this._child) : super(key: key);

  final Widget _child;

  @override
  Widget build(BuildContext context) => _child;
}
