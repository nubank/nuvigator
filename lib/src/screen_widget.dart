import 'package:flutter/material.dart';

import 'navigation_service.dart';
import 'screen.dart';

abstract class ScreenWidget<T extends Object> extends StatelessWidget {
  ScreenWidget(this.screenContext)
      : nuvigator = Nuvigator.of(screenContext.context),
        args = screenContext.settings.arguments;

  final ScreenContext screenContext;
  final NuvigatorState nuvigator;
  final T args;
}
