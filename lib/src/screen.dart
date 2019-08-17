import 'package:flutter/material.dart';
import 'package:nubank/nuds/nuds.dart';
import 'package:provider/provider.dart';

import 'navigation_service.dart';
import 'screen_widget.dart';
import 'transition_type.dart';

class ScreenContext {
  ScreenContext({this.context, this.settings})
      : navigation = NavigationService.of(context);

  final NavigationService navigation;
  final RouteSettings settings;
  final BuildContext context;
}

typedef ProvidersGeneratorFn = List<Provider> Function(
    ScreenContext screenContext);
typedef ScreenBuilder = ScreenWidget Function(ScreenContext screenContext);
typedef WrapperFn = Widget Function(
    ScreenContext screenContext, Widget screenWidget);

Widget defaultWrapperFn(ScreenContext _, Widget screenWidget) => screenWidget;

class Screen<T> {
  const Screen(
      {@required this.screenBuilder,
      this.wrapperFn = defaultWrapperFn,
      this.transitionType = TransitionType.page})
      : assert(screenBuilder != null);

  const Screen.page(
    ScreenBuilder screenBuilder,
  ) : this(screenBuilder: screenBuilder, transitionType: TransitionType.page);

  const Screen.card(
    ScreenBuilder screenBuilder,
  ) : this(screenBuilder: screenBuilder, transitionType: TransitionType.card);

  final ScreenBuilder screenBuilder;
  final TransitionType transitionType;
  final WrapperFn wrapperFn;

  Screen<T> withWrappedScreen(WrapperFn wrapperFn) {
    return Screen<T>(
      transitionType: transitionType,
      screenBuilder: screenBuilder,
      wrapperFn: wrapperFn ?? defaultWrapperFn,
    );
  }

  Route<T> toRoute(RouteSettings settings) {
    switch (transitionType) {
      case TransitionType.page:
        return NuDSPageRoute<T>(
          builder: (context) => _buildScreen(context, settings),
          settings: settings,
        );
      case TransitionType.card:
        return NuDSCardStackPageRoute<T>(
          builder: (context) => _buildScreen(context, settings),
          settings: settings,
        );
    }
    return null;
  }

  Widget _buildScreen(BuildContext context, RouteSettings settings) {
    return wrapperFn(
        ScreenContext(context: context, settings: settings),
        Builder(
          builder: (innerContext) => screenBuilder(
              ScreenContext(context: innerContext, settings: settings)),
        ));
  }
}
