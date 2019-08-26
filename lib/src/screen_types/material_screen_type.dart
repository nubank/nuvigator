import 'package:flutter/material.dart';

import '../screen_type.dart';

class MaterialScreenType extends ScreenType {
  const MaterialScreenType();

  @override
  Route<T> toRoute<T extends Object>(
      WidgetBuilder builder, RouteSettings settings) {
    return MaterialPageRoute(
      builder: builder,
      settings: settings,
    );
  }
}

const materialScreenType = MaterialScreenType();
