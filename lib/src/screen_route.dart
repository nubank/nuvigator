import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';
import 'package:nuvigator/src/router.dart';

import 'screen_type.dart';
import 'screen_types/cupertino_screen_type.dart';
import 'screen_types/material_screen_type.dart';

typedef WrapperFn = Widget Function(BuildContext context, Widget child);

class RouteDef {
  RouteDef(this.routeName, {this.deepLink});

  final String routeName;
  final String deepLink;

  @override
  bool operator ==(Object other) {
    return other is RouteDef && other.routeName == routeName;
  }

  @override
  int get hashCode => routeName.hashCode;
}

/// [T] is the possible return type of this Screen
class ScreenRoute<T extends Object> {
  const ScreenRoute({
    @required this.builder,
    this.wrapper,
    this.screenType,
    this.debugKey,
  }) : assert(builder != null);

  static ScreenRoute material<T extends Object>(WidgetBuilder widgetBuilder,
          {String debugKey}) =>
      ScreenRoute<T>(
          builder: widgetBuilder,
          screenType: materialScreenType,
          debugKey: debugKey);

  static ScreenRoute cupertino<T extends Object>(WidgetBuilder widgetBuilder,
          {String debugKey}) =>
      ScreenRoute<T>(
          builder: widgetBuilder,
          screenType: cupertinoScreenType,
          debugKey: debugKey);

  static ScreenRoute cupertinoDialog<T extends Object>(
          WidgetBuilder widgetBuilder,
          {String debugKey}) =>
      ScreenRoute<T>(
          builder: widgetBuilder,
          screenType: cupertinoDialogScreenType,
          debugKey: debugKey);

  final WidgetBuilder builder;
  final ScreenType screenType;
  final WrapperFn wrapper;
  final String debugKey;

  ScreenRoute<T> fallbackScreenType(ScreenType fallbackScreenType) {
    return ScreenRoute<T>(
      builder: builder,
      debugKey: debugKey,
      screenType: screenType ?? fallbackScreenType,
      wrapper: wrapper,
    );
  }

  ScreenRoute<T> wrapWith(WrapperFn wrapper) {
    if (wrapper == null) {
      return this;
    }
    return ScreenRoute<T>(
      builder: builder,
      debugKey: debugKey,
      screenType: screenType,
      wrapper: _getComposedWrapper(wrapper),
    );
  }

  ScreenRoute<T> copyWith({
    WidgetBuilder builder,
    ScreenType screenType,
    WrapperFn wrapper,
    String debugKey,
    String deepLink,
  }) {
    return ScreenRoute<T>(
      builder: builder ?? this.builder,
      screenType: screenType ?? this.screenType,
      wrapper: wrapper ?? this.wrapper,
      debugKey: debugKey ?? this.debugKey,
    );
  }

  Route<T> toRoute(RouteSettings settings) {
    return _toRouteType(
      (BuildContext context) => _buildScreen(context, settings),
      settings,
    );
  }

  WrapperFn _getComposedWrapper(WrapperFn wrapper) {
    if (wrapper != null) {
      return (BuildContext c, Widget child) => wrapper(
            c,
            Builder(
              builder: (context) =>
                  this.wrapper != null ? this.wrapper(context, child) : child,
            ),
          );
    }
    return this.wrapper;
  }

  Route<T> _toRouteType(WidgetBuilder builder, RouteSettings settings) =>
      screenType.toRoute<T>(builder, settings);

  Widget _buildScreen(BuildContext context, RouteSettings settings) {
    if (wrapper == null) return builder(context);
    return wrapper(
      context,
      Builder(
        builder: (innerContext) => builder(innerContext),
      ),
    );
  }
}

class FlowRoute<T extends Router, R extends Object> extends ScreenRoute<R> {
  FlowRoute({
    Nuvigator<T> nuvigator,
    WidgetBuilder builder,
    ScreenType screenType,
    String debugKey,
  }) : super(
          builder: nuvigator ?? builder,
          screenType: screenType,
          debugKey: debugKey,
        );
}
