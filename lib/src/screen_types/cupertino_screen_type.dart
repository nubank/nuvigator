import 'package:flutter/cupertino.dart';
import 'package:nuvigator/nuvigator.dart';

import '../screen_type.dart';

class NuvigatorCupertinoPageRoute<T> extends CupertinoPageRoute<T>
    with NuvigatorPageRoute<T> {
  NuvigatorCupertinoPageRoute({
    @required WidgetBuilder builder,
    String title,
    RouteSettings settings,
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
  Route<T> toRoute<T extends Object>(
      WidgetBuilder builder, NuRouteSettings settings) {
    return NuvigatorCupertinoPageRoute(
      builder: builder,
      fullscreenDialog: fullscreenDialog,
      settings: settings,
    );
  }
}

const cupertinoDialogScreenType = CupertinoScreenType(fullscreenDialog: true);
const cupertinoScreenType = CupertinoScreenType();
