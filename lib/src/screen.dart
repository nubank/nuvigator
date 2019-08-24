import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'navigation_service.dart';
import 'screen_widget.dart';
import 'transition_type.dart';

class ScreenContext {
  ScreenContext({this.context, this.settings})
      : navigation = NavigationService.of(context);

  ScreenContext copyWith({
    BuildContext context,
    RouteSettings settings,
  }) {
    return ScreenContext(
      context: context ?? this.context,
      settings: settings ?? this.settings,
    );
  }

  final NavigationService navigation;
  final RouteSettings settings;
  final BuildContext context;
}

typedef ScreenFn<T> = Screen<T> Function<T>(
    {WrapperFn wrapperFn, ScreenBuilder screenBuilder});
typedef ScreenBuilder = ScreenWidget Function(ScreenContext screenContext);
typedef WrapperFn = Widget Function(
    ScreenContext screenContext, Widget screenWidget);

Widget defaultWrapperFn(ScreenContext _, Widget screenWidget) => screenWidget;

class Screen<T> {
  const Screen(
      {@required this.screenBuilder,
      this.wrapperFn = defaultWrapperFn,
      this.transitionType = TransitionType.materialPage})
      : assert(screenBuilder != null);

  const Screen.page(
    ScreenBuilder screenBuilder,
  ) : this(
            screenBuilder: screenBuilder,
            transitionType: TransitionType.materialPage);

  const Screen.card(
    ScreenBuilder screenBuilder,
  ) : this(
            screenBuilder: screenBuilder,
            transitionType: TransitionType.cupertinoPage);

  final ScreenBuilder screenBuilder;
  final TransitionType transitionType;
  final WrapperFn wrapperFn;

  Screen<T> withWrappedScreen(WrapperFn wrapperFn) {
    return Screen<T>(
      transitionType: transitionType,
      screenBuilder: screenBuilder,
      wrapperFn: getComposedWrapper(wrapperFn),
    );
  }

  WrapperFn getComposedWrapper(WrapperFn wrapperFn) {
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

  Route<T> toRoute(RouteSettings settings) {
    switch (transitionType) {
      case TransitionType.materialPage:
        return MaterialPageRoute<T>(
          builder: (context) => buildScreen(context, settings),
          settings: settings,
        );
      case TransitionType.cupertinoPage:
        return CupertinoPageRoute<T>(
          builder: (context) => buildScreen(context, settings),
          settings: settings,
        );
    }
    return null;
  }

  Widget buildScreen(BuildContext context, RouteSettings settings) {
    return wrapperFn(
        ScreenContext(context: context, settings: settings),
        Builder(
          builder: (innerContext) => screenBuilder(
              ScreenContext(context: innerContext, settings: settings)),
        ));
  }
}
