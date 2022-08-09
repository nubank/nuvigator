import 'package:flutter/widgets.dart';
import 'package:path_to_regexp/path_to_regexp.dart';
import 'package:recase/recase.dart';
import './nu_route_settings.dart';

class DeepLinkParser<A extends Object?> {
  DeepLinkParser({
    required this.template,
    this.prefix = false,
    this.argumentParser,
  });

  final String template;
  final A Function(Map<String, dynamic>)? argumentParser;
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
  Map<String, dynamic> getParams(String deepLink) {
    return {...getQueryParams(deepLink), ...getPathParams(deepLink)};
  }

  /// Get only the queryParams of this deepLink
  Map<String, dynamic> getQueryParams(String deepLink) {
    final parametersMap = Uri.parse(deepLink).queryParametersAll.map(
      (key, value) {
        if (value.length == 1) {
          return MapEntry(key, value.first);
        } else {
          return MapEntry(key, value);
        }
      },
    );
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
    final match = regExp.matchAsPrefix(deepLinkPath)!;
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
  A? parseParams(Map<String, dynamic> params) {
    return argumentParser != null ? argumentParser!(params) : null;
  }

  /// Converts the DeepLink + extra parameters into a [NuRouteSettings]
  NuRouteSettings<A> toNuRouteSettings({
    required String deepLink,
    Object? arguments,
  }) {
    final qParams = getQueryParams(deepLink);
    final pParams = getPathParams(deepLink);
    final eParams = <String, dynamic>{};
    A? parsedArgs;

    if (arguments != null) {
      if (arguments is Map<String, dynamic>) {
        eParams.addAll(arguments);
      } else if (arguments is A) {
        debugPrint('The provided extra argument $arguments is of type $A.'
            ' Ignoring all deepLink encoded parameters for parsing purposes.');
        parsedArgs = arguments as A?;
      } else {
        throw FlutterError(
            'An incompatible extra argument ($arguments) was provided when trying to open'
            'the deepLink $deepLink. The argument should be either a Map<String, dynamic>'
            'or a instance of $A.');
      }
    }

    final allParams = <String, dynamic>{
      ...qParams,
      ...pParams,
      ...eParams,
    };

    return NuRouteSettings(
      name: deepLink,
      pathTemplate: template,
      queryParameters: qParams,
      pathParameters: pParams,
      extraParameters: eParams,
      arguments: parsedArgs ?? parseParams(allParams),
      scheme: getScheme(deepLink),
    );
  }
}
