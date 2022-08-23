import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './nu_route_settings.dart';
import 'screen_type.dart';
import 'typings.dart';

/// [T] is the possible return type of this Screen
class ScreenRoute<T extends Object?> {
  const ScreenRoute({
    required this.builder,
    required this.nuRouteSettings,
    this.wrapper,
    this.screenType,
    this.debugKey,
  });

  final WidgetBuilder builder;
  final ScreenType? screenType;
  final WrapperFn? wrapper;
  final NuRouteSettings nuRouteSettings;
  final String? debugKey;

  /// Creates a copy of the [ScreenRoute] with the new screen type
  ScreenRoute<T> fallbackScreenType(ScreenType? fallbackScreenType) {
    return ScreenRoute<T>(
      builder: builder,
      debugKey: debugKey,
      screenType: screenType ?? fallbackScreenType,
      wrapper: wrapper,
      nuRouteSettings: nuRouteSettings,
    );
  }

  /// Creates a copy of the [ScreenRoute] replacing the old properties with the
  /// new provided. For the non properties provided the old will be used.
  ScreenRoute<T> copyWith({
    WidgetBuilder? builder,
    ScreenType? screenType,
    WrapperFn? wrapper,
    String? debugKey,
    String? deepLink,
    NuRouteSettings? nuRouteSettings,
  }) {
    return ScreenRoute<T>(
      builder: builder ?? this.builder,
      screenType: screenType ?? this.screenType,
      wrapper: wrapper ?? this.wrapper,
      debugKey: debugKey ?? this.debugKey,
      nuRouteSettings: nuRouteSettings ?? this.nuRouteSettings,
    );
  }

  ///
  ScreenRoute<T> wrapWith(WrapperFn? wrapper) {
    if (wrapper == null) {
      return this;
    }
    return ScreenRoute<T>(
      builder: builder,
      debugKey: debugKey,
      screenType: screenType,
      nuRouteSettings: nuRouteSettings,
      wrapper: _getComposedWrapper(wrapper),
    );
  }

  WrapperFn _getComposedWrapper(WrapperFn wrapper) {
    return (BuildContext context, Widget child) => wrapper(
          context,
          Builder(
            builder: (innerContext) => this.wrapper != null
                ? this.wrapper!(innerContext, child)
                : child,
          ),
        );
  }

  Route<T> toRoute([RouteSettings? settings]) {
    return _toRouteType(
      (BuildContext context) => _buildScreen(context),
      settings ?? nuRouteSettings,
    );
  }

  Route<T> _toRouteType(WidgetBuilder builder, RouteSettings settings) {
    if (screenType == null) {
      throw FlutterError(
          'The screenRoute of $settings does not specify a ScreenType');
    }
    return screenType!.toRoute<T>(builder, settings);
  }

  Widget _buildScreen(BuildContext context) {
    if (wrapper == null) return builder(context);
    return wrapper!(
        context, Builder(builder: (innerContext) => builder(innerContext)));
  }
}
