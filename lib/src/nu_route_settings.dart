import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'route_path.dart';

class NuRouteSettings extends RouteSettings {
  const NuRouteSettings({
    @required this.routePath,
    @required String name,
    this.queryParams = const <String, dynamic>{},
    this.pathParams = const <String, dynamic>{},
    Object arguments,
  })  : _arguments = arguments,
        super(name: name);

  // Given that the matched route is not always the same as name (given we provide a pattern)
  final RoutePath routePath;

  final Map<String, dynamic> queryParams;
  final Map<String, dynamic> pathParams;
  final Object _arguments;

  @override
  Object get arguments {
    if (_arguments != null && _arguments is Map<String, dynamic>) {
      final Map<String, dynamic> mapParams = _arguments;
      return <String, dynamic>{...pathParams, ...queryParams, ...mapParams};
    } else if (_arguments != null) {
      if (queryParams.isNotEmpty || pathParams.isNotEmpty) {
        print(
            '''Warn: Provided Route arguments is not subtype of Map<String, dynamic>,
           query and path parameters are being ignored in favor of the passes argument.''');
      }
      return _arguments;
    } else {
      return <String, dynamic>{...pathParams, ...queryParams};
    }
  }

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
