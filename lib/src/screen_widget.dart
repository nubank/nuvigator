import 'package:flutter/material.dart';

import 'nuvigator.dart';
import 'screen.dart';

/// [T] is the type of the arguments this [ScreenWidget] may receive
abstract class ScreenWidget<T extends Object> extends StatelessWidget {
  ScreenWidget(this.screenContext)
      : nuvigator = Nuvigator.of(screenContext.context),
        args = screenContext.settings.arguments;

  final ScreenContext screenContext;
  final NuvigatorState nuvigator;
  final T args;
}
