import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:nuvigator/src/deeplink.dart';

class NuRouteSettings extends RouteSettings {
  const NuRouteSettings({
    @required String name,
    this.pathTemplate,
    this.scheme,
    this.parameters = const <String, dynamic>{},
  }) : super(name: name);

  final String pathTemplate;
  final String scheme;
  final Map<String, dynamic> parameters;

  Map<String, dynamic> get queryParams => _parser.getPathParams(name);

  @override
  Map<String, dynamic> get arguments => rawParams;

  Map<String, dynamic> get pathParams => _parser.getPathParams(name);

  DeepLinkParser get _parser => DeepLinkParser(pathTemplate);

  Map<String, dynamic> get rawParams {
    return <String, dynamic>{
      ...queryParams,
      ...pathParams,
      ...parameters,
    };
  }

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
