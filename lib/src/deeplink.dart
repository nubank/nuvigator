import 'package:nuvigator/src/nu_route_settings.dart';
import 'package:path_to_regexp/path_to_regexp.dart';
import 'package:recase/recase.dart';

class DeepLinkParser<A extends Object> {
  DeepLinkParser({
    this.template,
    this.prefix = false,
    this.argumentParser,
  });

  final String template;
  final A Function(Map<String, dynamic>) argumentParser;
  final bool prefix;

  String getPath(String deepLink) {
    final deepLinkWithoutScheme =
        deepLink.replaceFirst(RegExp(r'[\w]+://'), '');
    return deepLinkWithoutScheme.split('?').first;
  }

  bool matches(String deepLink) {
    final deepLinkWithoutQueryParameters = getPath(deepLink);
    final regExp = pathToRegExp(template, prefix: prefix);
    return regExp.hasMatch(deepLinkWithoutQueryParameters);
  }

  Map<String, String> getParams(String deepLink) {
    return {...getQueryParams(deepLink), ...getPathParams(deepLink)};
  }

  Map<String, String> getQueryParams(String deepLink) {
    final parametersMap = Uri.parse(deepLink).queryParameters;
    return {
      ...parametersMap,
      ...parametersMap.map((k, v) {
        return MapEntry(ReCase(k).camelCase, v);
      }),
    };
  }

  Map<String, String> getPathParams(String deepLink) {
    final parameters = <String>[];
    final deepLinkPath = getPath(deepLink);
    final regExp = pathToRegExp(template, parameters: parameters);
    final match = regExp.matchAsPrefix(deepLinkPath);
    final parametersMap = extract(parameters, match);
    return parametersMap.map((k, v) {
      return MapEntry(ReCase(k).camelCase, v);
    });
  }

  String getScheme(String deepLink) {
    return Uri.parse(deepLink).scheme;
  }

  A parseParams(Map<String, dynamic> params) {
    return argumentParser != null ? argumentParser(params) : null;
  }

  NuRouteSettings<A> toNuRouteSettings(
    String deepLink, {
    Map<String, dynamic> parameters,
    A args,
  }) {
    final qParams = getQueryParams(deepLink);
    final pParams = getPathParams(deepLink);
    final allParams = <String, dynamic>{
      ...qParams ?? const <String, dynamic>{},
      ...pParams ?? const <String, dynamic>{},
      ...parameters ?? const <String, dynamic>{},
    };
    return NuRouteSettings(
      name: deepLink,
      pathTemplate: template,
      queryParameters: qParams,
      pathParameters: pParams,
      extraParameter: parameters,
      args: parseParams(allParams),
      scheme: getScheme(deepLink),
    );
  }
}
