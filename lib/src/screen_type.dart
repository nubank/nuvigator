import 'package:flutter/widgets.dart';

import 'nuvigator.dart';

/// Mixing to add Nuvigator support for custom Route.
mixin NuvigatorPageRoute<T> on PageRoute<T> {
  NuvigatorState? get nuvigator {
    if (navigator is NuvigatorState) {
      return navigator as NuvigatorState<INuRouter>?;
    }
    return null;
  }

  /// Returns the closest NuvigatorPageRoute
  static NuvigatorPageRoute<R>? of<R>(BuildContext context) {
    final route = ModalRoute.of<R>(context);
    if (route is NuvigatorPageRoute) {
      return route as NuvigatorPageRoute<R>?;
    }
    return null;
  }

  bool get isNested => nuvigator != null && nuvigator!.isNested;

  /// If this Route is rendering a nested Nuvigator, it will be registered here
  NuvigatorState? nestedNuvigator;

  @override
  bool get fullscreenDialog {
    if (isNested && isFirst && ModalRoute.of(nuvigator!.context) is PageRoute) {
      final containedPageRoute =
          ModalRoute.of(nuvigator!.context) as PageRoute<dynamic>?;
      return super.fullscreenDialog || containedPageRoute!.fullscreenDialog;
    }
    return super.fullscreenDialog;
  }

  @override
  bool get canPop {
    return super.canPop || isNested;
  }

  @override
  Future<RoutePopDisposition> willPop() async {
    final res = await super.willPop();
    if (res == RoutePopDisposition.bubble && isNested) {
      return RoutePopDisposition.pop;
    }
    return res;
  }
}

abstract class ScreenType {
  const ScreenType();

  Route<T> toRoute<T extends Object?>(
      WidgetBuilder builder, RouteSettings settings);
}

class ScreenTypeBuilder extends ScreenType {
  ScreenTypeBuilder(this.builder);

  final Route<dynamic> Function(WidgetBuilder builder, RouteSettings setting)
      builder;

  @override
  Route<R> toRoute<R extends Object?>(
      WidgetBuilder builder, RouteSettings settings) {
    // ignore: avoid_as
    return this.builder(builder, settings) as Route<R>;
  }
}
