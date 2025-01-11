import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// [name] será a string completa do DeepLink
class NuRouteSettings<A extends Object?> extends RouteSettings {
  const NuRouteSettings({
    required String name,
    required this.pathTemplate,
    required this.scheme,
    A? arguments,
    this.queryParameters = const <String, dynamic>{},
    this.pathParameters = const <String, dynamic>{},
    this.extraParameters = const <String, dynamic>{},
  }) : super(name: name, arguments: arguments);

  final String pathTemplate;
  final String scheme;
  final Map<String, dynamic> queryParameters;
  final Map<String, dynamic> pathParameters;
  final Map<String, dynamic> extraParameters;

  /// Combina todos os parâmetros em um único mapa
  Map<String, dynamic> get rawParameters {
    return <String, dynamic>{
      ...queryParameters,
      ...pathParameters,
      ...extraParameters,
    };
  }

  /// Retorna os argumentos convertidos para o tipo A
  A? get args => arguments as A?;

  @override
  String toString() =>
      '${objectRuntimeType(this, 'NuRouteSettings')}("$name", "$pathTemplate", $rawParameters, $arguments)';

  @override
  int get hashCode => Object.hash(name, pathTemplate, rawParameters);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NuRouteSettings &&
        other.pathTemplate == pathTemplate &&
        other.name == name &&
        mapEquals(other.rawParameters, rawParameters);
  }
}
