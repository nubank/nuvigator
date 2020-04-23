import 'package:nuvigator/nuvigator.dart';
import 'package:path_to_regexp/path_to_regexp.dart';
import 'package:recase/recase.dart';

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

Map<String, String> extractDeepLinkParameters(String deepLink, RoutePath path) {
  final parameters = <String>[];
  final queryParameters = Uri.parse(deepLink).queryParameters;
  final match = matchPath(deepLink, path, parameters: parameters);
  final parametersMap = extract(parameters, match)..addAll(queryParameters);
  final camelCasedParametersMap = parametersMap.map((k, v) {
    return MapEntry(ReCase(k).camelCase, v);
  });
  return {...parametersMap, ...camelCasedParametersMap};
}
