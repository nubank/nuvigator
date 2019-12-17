import 'package:flutter/widgets.dart';

import '../nuvigator.dart';

mixin NuvigatorRoute<T> on PageRoute<T> {
  NuvigatorState get nuvigator => navigator;

  @override
  bool get canPop {
    return super.canPop || nuvigator.isNested;
  }

  @override
  Future<RoutePopDisposition> willPop() async {
    final res = await super.willPop();
    if (res == RoutePopDisposition.bubble && nuvigator.isNested) {
      return RoutePopDisposition.pop;
    }
    return res;
  }
}

abstract class ScreenType {
  const ScreenType();

  Route<T> toRoute<T extends Object>(
      WidgetBuilder builder, RouteSettings settings);
}
