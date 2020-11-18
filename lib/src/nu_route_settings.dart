import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:nuvigator/src/deeplink.dart';

/// [name] will be the full DeepLink String
class NuRouteSettings<A extends Object> extends RouteSettings {
  const NuRouteSettings({
    @required String name,
    this.scheme,
    this.pathTemplate,
    this.queryParameters,
    this.pathParameters,
    this.extraParameter,
    this.args,
  }) : super(name: name);

  final String pathTemplate;
  final String scheme;
  final A args;
  final Map<String, dynamic> queryParameters;
  final Map<String, dynamic> pathParameters;
  final Map<String, dynamic> extraParameter;

  @override
  Map<String, dynamic> get arguments => rawParameters;

  Map<String, dynamic> get rawParameters {
    return <String, dynamic>{
      ...queryParameters,
      ...pathParameters,
      ...extraParameter,
    };
  }

  @override
  String toString() =>
      '${objectRuntimeType(this, 'NuRouteSettings')}("$name", "$pathTemplate", $rawParameters)';

  @override
  int get hashCode => hashList([name, rawParameters, pathTemplate]);

  @override
  bool operator ==(Object other) =>
      other is NuRouteSettings &&
      other.pathTemplate == pathTemplate &&
      other.name == name &&
      other.rawParameters == rawParameters;
}
