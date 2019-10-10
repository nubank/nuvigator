import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'screen_type.dart';
import 'screen_types/cupertino_screen_type.dart';
import 'screen_types/material_screen_type.dart';

typedef WrapperFn = Widget Function(BuildContext context, Widget child);

Widget defaultWrapperFn(BuildContext _, Widget screenWidget) => screenWidget;

/// [T] is the possible return type of this Screen
class Screen<T extends Object> {
  const Screen({
    @required this.builder,
    this.wrapperFn,
    this.screenType,
    this.debugKey,
    this.deepLink,
  }) : assert(builder != null);

  static Screen material<T extends Object>(WidgetBuilder widgetBuilder,
          {String debugKey}) =>
      Screen<T>(
          builder: widgetBuilder,
          screenType: materialScreenType,
          debugKey: debugKey);

  static Screen cupertino<T extends Object>(WidgetBuilder widgetBuilder,
          {String debugKey}) =>
      Screen<T>(
          builder: widgetBuilder,
          screenType: cupertinoScreenType,
          debugKey: debugKey);

  static Screen cupertinoDialog<T extends Object>(WidgetBuilder widgetBuilder,
          {String debugKey}) =>
      Screen<T>(
          builder: widgetBuilder,
          screenType: cupertinoDialogScreenType,
          debugKey: debugKey);

  final WidgetBuilder builder;
  final ScreenType screenType;
  final WrapperFn wrapperFn;
  final String debugKey;
  final String deepLink;
//  final A Function(Map<String, String>) parseDeepLinkArgs;

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

  Screen<T> copyWith({
    WidgetBuilder builder,
    ScreenType screenType,
    WrapperFn wrapperFn,
    String debugKey,
    String deepLink,
  }) {
    return Screen<T>(
      builder: builder ?? this.builder,
      screenType: screenType ?? this.screenType,
      wrapperFn: wrapperFn ?? this.wrapperFn,
      debugKey: debugKey ?? this.debugKey,
      deepLink: deepLink ?? this.deepLink,
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
      return (BuildContext c, Widget child) => wrapperFn(
            c,
            Builder(
              builder: (context) => this.wrapperFn != null
                  ? this.wrapperFn(context, child)
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
      context,
      Builder(
        builder: (innerContext) => builder(innerContext),
      ),
    );
  }
}
