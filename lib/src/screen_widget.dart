import 'package:flutter/material.dart';

import 'navigation_service.dart';
import 'screen.dart';

abstract class ScreenWidget<T extends Object> extends StatelessWidget {
  ScreenWidget(this.screenContext)
      : navigation = screenContext.navigation,
        args = screenContext.settings.arguments;

  final ScreenContext screenContext;
  final NavigationService navigation;
  final T args;
}
