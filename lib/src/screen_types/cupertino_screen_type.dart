import 'package:flutter/cupertino.dart';

import '../screen_type.dart';

class CupertinoScreenType extends ScreenType {
  const CupertinoScreenType();

  @override
  Route<T> toRoute<T extends Object>(
      WidgetBuilder builder, RouteSettings settings) {
    return CupertinoPageRoute(
      builder: builder,
      settings: settings,
    );
  }
}

class CupertinoDialogScreenType extends ScreenType {
  const CupertinoDialogScreenType();

  @override
  Route<T> toRoute<T extends Object>(
      WidgetBuilder builder, RouteSettings settings) {
    return CupertinoPageRoute(
      builder: builder,
      fullscreenDialog: true,
      settings: settings,
    );
  }
}

const cupertinoDialogScreenType = CupertinoDialogScreenType();
const cupertinoScreenType = CupertinoScreenType();
