import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// [name] will be the full DeepLink String
class NuRouteSettings<A extends Object> extends RouteSettings {
  const NuRouteSettings({
    @required String name,
    A arguments,
    this.scheme,
    this.pathTemplate,
    this.queryParameters = const <String, dynamic>{},
    this.pathParameters = const <String, dynamic>{},
  }) : super(name: name, arguments: arguments);

  final String pathTemplate;
  final String scheme;
  final Map<String, dynamic> queryParameters;
  final Map<String, dynamic> pathParameters;

  Map<String, dynamic> get rawParameters {
    return <String, dynamic>{
      ...queryParameters ?? const <String, dynamic>{},
      ...pathParameters ?? const <String, dynamic>{},
      ...arguments is Map<String, dynamic>
          // ignore: avoid_as
          ? arguments as Map<String, dynamic>
          : const <String, dynamic>{},
    };
  }

  A get args => arguments;

  @override
  String toString() =>
      '${objectRuntimeType(this, 'NuRouteSettings')}("$name", "$pathTemplate", $rawParameters)';

  @override
  int get hashCode => hashList([name, rawParameters, pathTemplate]);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NuRouteSettings &&
        other.pathTemplate == pathTemplate &&
        other.name == name &&
        other.rawParameters == rawParameters;
  }
}
