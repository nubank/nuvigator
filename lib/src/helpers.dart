import 'package:path_to_regexp/path_to_regexp.dart';
import 'package:recase/recase.dart';

import 'route_path.dart';

RegExp pathToRegex(RoutePath path, {List<String> parameters}) {
  return pathToRegExp(path.path, parameters: parameters, prefix: path.prefix);
}

/// Removes query parameters and keep just the path part of the DeepLink
String deepLinkToPath(String deepLink) {
  return deepLink.split('?').first;
}

Match matchPath(String deepLink, RoutePath path, {List<String> parameters}) {
  return pathToRegex(path, parameters: parameters)
      .matchAsPrefix(deepLinkToPath(deepLink));
}

bool pathMatches(String deepLink, RoutePath path) =>
    matchPath(deepLink, path) != null;

Map<String, String> convertCase(Map<String, String> input) {
  return input.map((k, v) {
    return MapEntry(ReCase(k).camelCase, v);
  });
}

Map<String, String> deepLinkPathParams(String deepLink, RoutePath path) {
  final parameters = <String>[];
  final match = matchPath(deepLink, path, parameters: parameters);
  final parametersMap = extract(parameters, match);
  return convertCase(parametersMap);
}

Map<String, String> deepLinkQueryParams(String deepLink) {
  final queryParameters = Uri.parse(deepLink).queryParameters;
  return {
    ...queryParameters,
    ...convertCase(queryParameters),
  };
}

String trimPrefix(String path, String prefix) {
  return path.replaceFirst(RegExp('^$prefix'), '');
}

bool boolFromString(String boolValue) {
  switch (boolValue?.toLowerCase()) {
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      return null;
  }
}
