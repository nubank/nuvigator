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

  /// Return the deepLink without the scheme and query parameters
  String getPath(String deepLink) {
    final deepLinkWithoutScheme =
        deepLink.replaceFirst(RegExp(r'[\w]+://'), '');
    return deepLinkWithoutScheme.split('?').first;
  }

  /// Verifies if the deepLink matches against this parser based on the template
  bool matches(String deepLink) {
    final deepLinkWithoutQueryParameters = getPath(deepLink);
    final regExp = pathToRegExp(template, prefix: prefix);
    return regExp.hasMatch(deepLinkWithoutQueryParameters);
  }

  /// Get all the query and path params of this deepLink
  Map<String, String> getParams(String deepLink) {
    return {...getQueryParams(deepLink), ...getPathParams(deepLink)};
  }

  /// Get only the queryParams of this deepLink
  Map<String, String> getQueryParams(String deepLink) {
    final parametersMap = Uri.parse(deepLink).queryParameters;
    return {
      ...parametersMap,
      ...parametersMap.map((k, v) {
        return MapEntry(ReCase(k).camelCase, v);
      }),
    };
  }

  /// Get only the pathParams of this deepLinks
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

  /// Gets the scheme used in this deepLink
  String getScheme(String deepLink) {
    return Uri.parse(deepLink).scheme;
  }

  /// Uses the provided ParserFn to parse all the params in this deepLink
  A parseParams(Map<String, dynamic> params) {
    return argumentParser != null ? argumentParser(params) : null;
  }

  /// Converts the DeepLink + extra parameters into a [NuRouteSettings]
  NuRouteSettings<A> toNuRouteSettings(
    String deepLink, {
    Map<String, dynamic> parameters,
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
