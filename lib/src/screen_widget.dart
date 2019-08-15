import 'package:flutter/material.dart';

import '../routing.dart';
import 'navigation_service.dart';

abstract class ScreenWidget extends StatelessWidget {
  ScreenWidget(this.screenContext)
      : navigation = screenContext.navigation,
        args = screenContext.settings.arguments;

  final ScreenContext screenContext;
  final NavigationService navigation;
  final Map<String, dynamic> args;
}
