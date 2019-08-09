import 'package:flutter/material.dart';
import 'package:nuds/nuds.dart';
import 'package:provider/provider.dart';

import 'navigation_service.dart';
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
typedef ScreenBuilder = Widget Function(ScreenContext screenContext);

class Screen<T> {
  const Screen(
      {@required this.screenBuilder,
      this.generateProviders,
      this.transitionType = TransitionType.page})
      : assert(screenBuilder != null);

  const Screen.page(ScreenBuilder screenBuilder,
      {ProvidersGeneratorFn generateProviders})
      : this(
            screenBuilder: screenBuilder,
            generateProviders: generateProviders,
            transitionType: TransitionType.page);

  const Screen.card(ScreenBuilder screenBuilder,
      {ProvidersGeneratorFn generateProviders})
      : this(
            screenBuilder: screenBuilder,
            generateProviders: generateProviders,
            transitionType: TransitionType.card);

  final ScreenBuilder screenBuilder;
  final TransitionType transitionType;
  final ProvidersGeneratorFn generateProviders;

  Screen<T> withProviders(ProvidersGeneratorFn providersGeneratorFn) {
    return Screen<T>(
      transitionType: transitionType,
      screenBuilder: screenBuilder,
      generateProviders: providersGeneratorFn,
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
    final screenContext = ScreenContext(context: context, settings: settings);
    return MultiProvider(
      providers:
          generateProviders != null ? generateProviders(screenContext) : [],
      child: screenBuilder(screenContext),
    );
  }
}
