import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';
import 'package:nuvigator/src/router.dart';

import 'screen_type.dart';
import 'screen_types/cupertino_screen_type.dart';
import 'screen_types/material_screen_type.dart';

/// [T] is the possible return type of this Screen
class ScreenRoute<T extends Object> {
  const ScreenRoute({
    @required this.builder,
    this.screenType,
    this.debugKey,
    this.deepLink,
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
  final String debugKey;
  final String deepLink;

  ScreenRoute<T> fallbackScreenType(ScreenType fallbackScreenType) {
    return ScreenRoute<T>(
      builder: builder,
      debugKey: debugKey,
      screenType: screenType ?? fallbackScreenType,
    );
  }

  ScreenRoute<T> copyWith({
    WidgetBuilder builder,
    ScreenType screenType,
    String debugKey,
    String deepLink,
  }) {
    return ScreenRoute<T>(
      builder: builder ?? this.builder,
      screenType: screenType ?? this.screenType,
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

  Route<T> _toRouteType(WidgetBuilder builder, RouteSettings settings) =>
      screenType.toRoute<T>(builder, settings);

  Widget _buildScreen(BuildContext context, RouteSettings settings) {
    return Builder(
      builder: (innerContext) => builder(innerContext),
    );
  }
}

class FlowRoute<T extends Router, R extends Object> extends ScreenRoute<R> {
  FlowRoute({
    @required Nuvigator<T> nuvigator,
    String deepLink,
    ScreenType screenType,
    String debugKey,
  }) : super(
          builder: nuvigator,
          deepLink: deepLink,
          screenType: screenType,
          debugKey: debugKey,
        );
}
