import 'package:flutter/cupertino.dart';

import '../screen_type.dart';

class CupertinoScreenType extends ScreenType {
  const CupertinoScreenType({this.fullscreenDialog = false});

  final bool fullscreenDialog;

  @override
  Route<T> toRoute<T extends Object>(
      WidgetBuilder builder, RouteSettings settings) {
    return CupertinoPageRoute(
      builder: builder,
      fullscreenDialog: fullscreenDialog,
      settings: settings,
    );
  }
}

const cupertinoDialogScreenType = CupertinoScreenType(fullscreenDialog: true);
const cupertinoScreenType = CupertinoScreenType();
