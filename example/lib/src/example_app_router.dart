import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';

class NuCardScreenType extends ScreenType {
  @override
  Route<T> toRoute<T extends Object>(
      WidgetBuilder builder, RouteSettings settings) {
    return MaterialPageRoute(
      builder: builder,
      settings: settings,
    );
  }
}

final nuCardScreenType = NuCardScreenType();

class NuPageScreenType extends ScreenType {
  @override
  Route<T> toRoute<T extends Object>(
      WidgetBuilder builder, RouteSettings settings) {
    return CupertinoPageRoute(
      builder: builder,
      settings: settings,
    );
  }
}

final nuPageScreenType = NuPageScreenType();

class NuScreen {
  static Screen page<T extends Object>(ScreenBuilder screenBuilder) {
    return Screen<T>(
        screenBuilder: screenBuilder, screenType: nuPageScreenType);
  }

  static Screen card<T extends Object>(ScreenBuilder screenBuilder) {
    return Screen<T>(
        screenBuilder: screenBuilder, screenType: nuCardScreenType);
  }
}
