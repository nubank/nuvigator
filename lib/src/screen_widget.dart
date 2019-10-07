import 'package:flutter/material.dart';

import 'nuvigator.dart';

/// [T] is the type of the arguments this [ScreenWidget] may receive
abstract class ScreenWidget<T extends Object> extends StatelessWidget {
  ScreenWidget(this.context)
      : nuvigator = Nuvigator.of(context),
        args = ModalRoute.of(context).settings.arguments;

  final BuildContext context;
  final NuvigatorState nuvigator;
  final T args;
}
