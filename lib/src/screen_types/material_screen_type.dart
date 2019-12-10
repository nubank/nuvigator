import 'package:flutter/material.dart';

import '../screen_type.dart';

class MaterialScreenType extends ScreenType {
  const MaterialScreenType({this.fullscreenDialog = false});

  final bool fullscreenDialog;

  @override
  Route<T> toRoute<T extends Object>(
      WidgetBuilder builder, RouteSettings settings) {
    return MaterialPageRoute(
      builder: builder,
      settings: settings,
      fullscreenDialog: fullscreenDialog,
    );
  }
}

const materialScreenType = MaterialScreenType();
const materialFullScreenType = MaterialScreenType(fullscreenDialog: true);
