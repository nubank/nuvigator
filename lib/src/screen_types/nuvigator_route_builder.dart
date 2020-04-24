import 'package:flutter/cupertino.dart';
import 'package:nuvigator/nuvigator.dart';

class NuvigatorRouteBuilder<T> extends PageRouteBuilder<T>
    with NuvigatorPageRoute<T> {
  NuvigatorRouteBuilder({
    RouteSettings settings,
    @required RoutePageBuilder pageBuilder,
    RouteTransitionsBuilder transitionsBuilder,
    Duration transitionDuration,
    bool opaque,
    bool barrierDismissible,
    Color barrierColor,
    String barrierLabel,
    bool maintainState,
    bool fullscreenDialog,
  }) : super(
          settings: settings,
          pageBuilder: pageBuilder,
          transitionsBuilder: transitionsBuilder,
          transitionDuration: transitionDuration,
          opaque: opaque,
          barrierColor: barrierColor,
          barrierDismissible: barrierDismissible,
          barrierLabel: barrierLabel,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        );
}

class ScreenTypeBuilder extends ScreenType {
  ScreenTypeBuilder(this.routeBuilder);

  final NuvigatorRouteBuilder<T> Function<T>(WidgetBuilder, RouteSettings)
      routeBuilder;

  @override
  Route<T> toRoute<T extends Object>(
      WidgetBuilder builder, RouteSettings settings) {
    return routeBuilder<T>(builder, settings);
  }
}
