import 'package:flutter/widgets.dart';

import '../screen_type.dart';

class GenericScreenType extends ScreenType {
  const GenericScreenType(this.route);

  final Route<dynamic> route;

  @override
  Route<R> toRoute<R>(WidgetBuilder builder, RouteSettings settings) {
    return route;
  }
}
