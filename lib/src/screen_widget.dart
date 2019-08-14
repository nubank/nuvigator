import 'package:flutter/material.dart';

import '../routing.dart';
import 'navigation.dart';

abstract class ScreenWidget extends StatelessWidget {
  ScreenWidget(this.screenContext)
      : navigation = screenContext.navigation,
        args = screenContext.settings.arguments;

  final ScreenContext screenContext;
  final Navigation navigation;
  final Map<String, dynamic> args;
}
