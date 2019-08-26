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

const cupertinoScreenType = CupertinoScreenType();
