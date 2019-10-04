import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'screen_type.dart';
import 'screen_types/cupertino_screen_type.dart';
import 'screen_types/material_screen_type.dart';

class ScreenContext {
  ScreenContext({this.context, this.settings});

  ScreenContext copyWith({
    BuildContext context,
    RouteSettings settings,
  }) {
    return ScreenContext(
      context: context ?? this.context,
      settings: settings ?? this.settings,
    );
  }

  final RouteSettings settings;
  final BuildContext context;
}

typedef ScreenBuilder = Widget Function(ScreenContext screenContext);
typedef WrapperFn = Widget Function(ScreenContext screenContext, Widget child);

Widget defaultWrapperFn(ScreenContext _, Widget screenWidget) => screenWidget;

/// [T] is the possible return type of this Screen
class Screen<T extends Object> {
  const Screen({
    @required this.builder,
    this.wrapperFn,
    this.screenType,
    this.debugKey,
  }) : assert(builder != null);

  static Screen material<T extends Object>(ScreenBuilder screenBuilder,
          {String debugKey}) =>
      Screen<T>(
          builder: screenBuilder,
          screenType: materialScreenType,
          debugKey: debugKey);

  static Screen cupertino<T extends Object>(ScreenBuilder screenBuilder,
          {String debugKey}) =>
      Screen<T>(
          builder: screenBuilder,
          screenType: cupertinoScreenType,
          debugKey: debugKey);

  static Screen cupertinoDialog<T extends Object>(ScreenBuilder screenBuilder,
          {String debugKey}) =>
      Screen<T>(
          builder: screenBuilder,
          screenType: cupertinoDialogScreenType,
          debugKey: debugKey);

  final ScreenBuilder builder;
  final ScreenType screenType;
  final WrapperFn wrapperFn;
  final String debugKey;

  Screen<T> fallbackScreenType(ScreenType fallbackScreenType) {
    return Screen<T>(
      builder: builder,
      debugKey: debugKey,
      screenType: screenType ?? fallbackScreenType,
      wrapperFn: wrapperFn,
    );
  }

  Screen<T> wrapWith(WrapperFn wrapperFn) {
    if (wrapperFn == null) {
      return this;
    }
    return Screen<T>(
      builder: builder,
      debugKey: debugKey,
      screenType: screenType,
      wrapperFn: _getComposedWrapper(wrapperFn),
    );
  }

  Route<T> toRoute(RouteSettings settings) {
    return _toRouteType(
      (BuildContext context) => _buildScreen(context, settings),
      settings,
    );
  }

  WrapperFn _getComposedWrapper(WrapperFn wrapperFn) {
    if (wrapperFn != null) {
      return (ScreenContext sc, Widget child) => wrapperFn(
            sc,
            Builder(
              builder: (context) => this.wrapperFn != null
                  ? this.wrapperFn(sc?.copyWith(context: context), child)
                  : child,
            ),
          );
    }
    return this.wrapperFn;
  }

  Route<T> _toRouteType(WidgetBuilder builder, RouteSettings settings) =>
      screenType.toRoute<T>(builder, settings);

  Widget _buildScreen(BuildContext context, RouteSettings settings) {
    return wrapperFn(
        ScreenContext(context: context, settings: settings),
        Builder(
          builder: (innerContext) =>
              builder(ScreenContext(context: innerContext, settings: settings)),
        ));
  }
}
