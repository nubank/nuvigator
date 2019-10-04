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
typedef WrapperFn = Widget Function(
    ScreenContext screenContext, Widget screenWidget);

Widget defaultWrapperFn(ScreenContext _, Widget screenWidget) => screenWidget;

class Screen<T extends Object> {
  const Screen({
    @required this.screenBuilder,
    this.wrapperFn = defaultWrapperFn,
    this.screenType = materialScreenType,
    this.debugKey,
  }) : assert(screenBuilder != null);

  static Screen material<T>(ScreenBuilder screenBuilder, {String debugKey}) =>
      Screen<T>(
          screenBuilder: screenBuilder,
          screenType: materialScreenType,
          debugKey: debugKey);

  static Screen cupertino<T>(ScreenBuilder screenBuilder, {String debugKey}) =>
      Screen<T>(
          screenBuilder: screenBuilder,
          screenType: cupertinoScreenType,
          debugKey: debugKey);

  static Screen cupertinoDialog<T>(ScreenBuilder screenBuilder,
          {String debugKey}) =>
      Screen<T>(
          screenBuilder: screenBuilder,
          screenType: cupertinoDialogScreenType,
          debugKey: debugKey);

  final ScreenBuilder screenBuilder;
  final ScreenType screenType;
  final WrapperFn wrapperFn;
  final String debugKey;

  Screen<T> wrapWith(WrapperFn wrapperFn) {
    if (wrapperFn == null) {
      return this;
    }
    return Screen<T>(
      debugKey: debugKey,
      screenType: screenType,
      screenBuilder: screenBuilder,
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
              builder: (context) =>
                  this.wrapperFn(sc?.copyWith(context: context), child),
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
          builder: (innerContext) => screenBuilder(
              ScreenContext(context: innerContext, settings: settings)),
        ));
  }
}
