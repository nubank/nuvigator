import 'package:flutter/widgets.dart';

abstract class ScreenType {
  const ScreenType();

  Route<T> toRoute<T extends Object>(
      WidgetBuilder builder, RouteSettings settings);
}
