import 'package:flutter/cupertino.dart';

import '../screen_type.dart';

class _NuCupertinoPageRoute<T> extends CupertinoPageRoute<T>
    with NuvigatorPageRoute<T> {
  _NuCupertinoPageRoute({
    required WidgetBuilder builder,
    String? title,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
          builder: builder,
          title: title,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        );
}

class CupertinoScreenType extends ScreenType {
  const CupertinoScreenType({this.fullscreenDialog = false});

  final bool fullscreenDialog;

  @override
  Route<T> toRoute<T extends Object?>(
      WidgetBuilder builder, RouteSettings settings) {
    return _NuCupertinoPageRoute(
      builder: builder,
      fullscreenDialog: fullscreenDialog,
      settings: settings,
    );
  }
}

const cupertinoDialogScreenType = CupertinoScreenType(fullscreenDialog: true);
const cupertinoScreenType = CupertinoScreenType();
