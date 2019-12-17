import 'package:flutter/material.dart';

import '../screen_type.dart';

class NuvigatorMaterialPageRoute<T> extends MaterialPageRoute<T>
    with NuvigatorRoute<T> {
  NuvigatorMaterialPageRoute({
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
    return NuvigatorMaterialPageRoute(
      builder: builder,
      settings: settings,
    );
  }
}

const materialScreenType = MaterialScreenType();
