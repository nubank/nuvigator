import 'package:flutter/material.dart';
import 'package:nubank/nuds/src/navigation/card_stack_route.dart';
import 'package:nubank/nuds/src/navigation/page_route.dart';
import 'package:provider/provider.dart';

import 'navigation.dart';
import 'transition_type.dart';

class ScreenContext {
  ScreenContext({this.context, this.settings})
      : navigation = Navigation.of(context);

  final Navigation navigation;
  final RouteSettings settings;
  final BuildContext context;
}

typedef ProvidersGeneratorFn = List<Provider> Function(
    ScreenContext screenContext);
typedef ScreenBuilder<T> = Widget Function(ScreenContext screenContext);

class Screen {
  const Screen(
      {this.screenBuilder,
      this.generateProviders,
      this.transitionType = TransitionType.page});

  const Screen.page(this.screenBuilder, {this.generateProviders})
      : transitionType = TransitionType.page;

  const Screen.card(this.screenBuilder, {this.generateProviders})
      : transitionType = TransitionType.card;

  final ScreenBuilder screenBuilder;
  final TransitionType transitionType;
  final ProvidersGeneratorFn generateProviders;

  Screen withProviders(ProvidersGeneratorFn providersGeneratorFn) {
    return Screen(
      transitionType: transitionType,
      screenBuilder: screenBuilder,
      generateProviders: providersGeneratorFn,
    );
  }

  Route toRoute(RouteSettings settings) {
    switch (transitionType) {
      case TransitionType.page:
        return NuDSPageRoute<void>(
          builder: (context) => _buildScreen(context, settings),
          settings: settings,
        );
      case TransitionType.card:
        return NuDSCardStackPageRoute<void>(
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
