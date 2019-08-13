import 'package:flutter/material.dart';

import 'navigation.dart';

abstract class ScreenWidget extends StatelessWidget {
  const ScreenWidget(this.navigation);

  final Navigation navigation;

  Map<String, dynamic> get args =>
      ModalRoute.of(navigation.context).settings.arguments;
}
