import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'route_path.dart';

class NuRouteSettings extends RouteSettings {
  const NuRouteSettings({
    @required this.routePath,
    @required String name,
    Object arguments,
  }) : super(name: name, arguments: arguments);

  // Given that the matched route is not always the same as name (given we provide a pattern)
  final RoutePath routePath;

  @override
  String toString() =>
      '${objectRuntimeType(this, 'NuRouteSettings')}("$name", "$routePath", $arguments)';

  @override
  int get hashCode => hashList([name, arguments, routePath]);

  @override
  bool operator ==(Object other) =>
      other is NuRouteSettings &&
      other.routePath == routePath &&
      other.name == name &&
      other.arguments == arguments;
}

class NuRouteSettingsProvider extends InheritedWidget {
  const NuRouteSettingsProvider(
      {Key key, @required this.routeSettings, @required Widget child})
      : assert(routeSettings != null),
        assert(child != null),
        super(key: key, child: child);

  final NuRouteSettings routeSettings;

  static NuRouteSettings of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<NuRouteSettingsProvider>()
        ?.routeSettings;
  }

  @override
  bool updateShouldNotify(NuRouteSettingsProvider oldWidget) {
    return oldWidget.routeSettings != routeSettings;
  }
}
