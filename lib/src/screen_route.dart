import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';

import 'nu_route_settings.dart';
import 'screen_type.dart';

typedef WrapperFn = Widget Function(BuildContext context, Widget child);

/// [T] is the possible return type of this Screen
class ScreenRoute<T extends Object> {
  const ScreenRoute({
    @required this.builder,
    this.wrapper,
    this.screenType,
    this.debugKey,
  }) : assert(builder != null);

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

  Route<T> toRoute(NuRouteSettings settings) {
    return _toRouteType(
      (BuildContext context) => _buildScreen(context, settings),
      settings,
    );
  }

  Route<T> _toRouteType(WidgetBuilder builder, NuRouteSettings settings) =>
      screenType.toRoute<T>(builder, settings);

  Widget _buildScreen(BuildContext context, NuRouteSettings settings) {
    final child = wrapper == null
        ? builder(context)
        : wrapper(
            context, Builder(builder: (innerContext) => builder(innerContext)));
    return NuRouteSettingsProvider(
      child: child,
      routeSettings: settings,
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
}
