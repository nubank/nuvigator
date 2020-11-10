import 'package:flutter/material.dart';

import '../screen_type.dart';

class NuMaterialPageRoute<T> extends MaterialPageRoute<T>
    with NuvigatorPageRoute<T> {
  NuMaterialPageRoute({
    @required WidgetBuilder builder,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
          builder: builder,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        );
}

class MaterialScreenType extends ScreenType {
  const MaterialScreenType();

  @override
  Route<T> toRoute<T extends Object>(
      WidgetBuilder builder, RouteSettings settings) {
    return NuMaterialPageRoute(
      builder: builder,
      settings: settings,
    );
  }
}

const materialScreenType = MaterialScreenType();
