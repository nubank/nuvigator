import 'package:nuvigator/src/nu_route_settings.dart';
import 'package:path_to_regexp/path_to_regexp.dart';
import 'package:recase/recase.dart';

class DeepLinkParser<A> {
  DeepLinkParser({
    this.template,
    this.prefix = false,
    this.argumentParser,
  });

  final String template;
  final A Function(Map<String, dynamic>) argumentParser;
  final bool prefix;

  bool matches(String deepLink) {
    // TODO: Create a test with something like this
    // nuapp://blabla?route=http://bla2?route=bla
    final deepLinkWithoutScheme =
        deepLink.replaceFirst(RegExp(r'[\w]+://'), '');
    final deepLinkWithoutQueryParameters =
        deepLinkWithoutScheme.split('?').first;
    final regExp = pathToRegExp(template, prefix: prefix);
    return regExp.hasMatch(deepLinkWithoutQueryParameters);
  }

  Map<String, String> getParams(String deepLink) {
    return {...getQueryParams(deepLink), ...getPathParams(deepLink)};
  }

  Map<String, String> getQueryParams(String deepLink) {
    print(deepLink);
    final parametersMap = Uri.parse(deepLink).queryParameters;
    return parametersMap.map((k, v) {
      return MapEntry(ReCase(k).camelCase, v);
    });
  }

  Map<String, String> getPathParams(String deepLink) {
    final parameters = <String>[];
    final regExp = pathToRegExp(template, parameters: parameters);
    final match = regExp.matchAsPrefix(deepLink);
    final parametersMap = extract(parameters, match);
    return parametersMap.map((k, v) {
      return MapEntry(ReCase(k).camelCase, v);
    });
  }

  String getSchema(String deepLink) {
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
    final allParams = <String, dynamic>{...qParams, ...pParams, ...parameters};
    return NuRouteSettings(
      name: deepLink,
      pathTemplate: template,
      queryParameters: qParams,
      pathParameters: pParams,
      extraParameter: parameters,
      args: parseParams(allParams),
      scheme: getSchema(deepLink),
    );
  }
}
