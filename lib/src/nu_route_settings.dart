import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class NuRouteSettings<A extends Object> extends RouteSettings {
  const NuRouteSettings({
    @required String name,
    @required this.pathTemplate,
    @required this.scheme,
    this.extraParams = const <String, dynamic>{},
    this.queryParams = const <String, dynamic>{},
    this.pathParams = const <String, dynamic>{},
  }) : super(name: name);

  final String pathTemplate;
  final String scheme;
  final Map<String, dynamic> queryParams;
  final Map<String, dynamic> pathParams;
  final Map<String, dynamic> extraParams;

  Map<String, dynamic> get rawParams {
    return <String, dynamic>{...queryParams, ...pathParams, ...extraParams};
  }

  @override
  A get arguments => null;

  @override
  String toString() =>
      '${objectRuntimeType(this, 'NuRouteSettings')}("$name", "$pathTemplate", $rawParams)';

  @override
  int get hashCode => hashList([name, rawParams, pathTemplate]);

  @override
  bool operator ==(Object other) =>
      other is NuRouteSettings &&
      other.pathTemplate == pathTemplate &&
      other.name == name &&
      other.rawParams == rawParams;
}
