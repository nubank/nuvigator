import 'package:flutter/material.dart';

import '../nurouter.dart';

@immutable
class NuRoutePath {
  const NuRoutePath({
    this.deepLink,
    this.scheme,
    this.template,
    this.pathParams,
    this.queryParams,
  });

  final String deepLink;
  final String template;
  final Map<String, String> queryParams;
  final Map<String, String> pathParams;
  final String scheme;
}

class NuvigatorRouterDelegate extends RouterDelegate<NuRoutePath>
    with ChangeNotifier {
  NuvigatorRouterDelegate();

  final List<Page> _pages = [];

  List<Page> get pages => List<Page>.unmodifiable(_pages);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: _pages,
    );
  }

  @override
  Future<bool> popRoute() async {
    _pages.removeLast();
    notifyListeners();
    return false;
  }

  @override
  Future<void> setNewRoutePath(NuRoutePath configuration) async {
    _pages.add(MaterialPage<void>(child: Container()));
    notifyListeners();
    return false;
  }
}

class Nuvigator extends StatelessWidget {
  Nuvigator({Key key, this.initialRoute, this.nuRouter, this.initialArgs})
      : super(key: key);

  final RouterDelegate<NuRoutePath> delegate = NuvigatorRouterDelegate();
  final String initialRoute;
  final NuRouter nuRouter;
  final Object initialArgs;

  @override
  Widget build(BuildContext context) {
    return Router<NuRoutePath>(routerDelegate: delegate);
  }
}
