import 'package:nuvigator/nuvigator.dart';
import 'package:path_to_regexp/path_to_regexp.dart';
import 'package:recase/recase.dart';

RegExp pathToRegex(RoutePath path, {List<String> parameters}) {
  return pathToRegExp(path.path, parameters: parameters, prefix: path.prefix);
}

Map<String, String> extractDeepLinkParameters(String deepLink, RoutePath path) {
  final parameters = <String>[];
  final regExp = pathToRegex(path, parameters: parameters);
  final match = regExp.matchAsPrefix(deepLink);
  final parametersMap = extract(parameters, match)
    ..addAll(Uri.parse(deepLink).queryParameters);
  final camelCasedParametersMap = parametersMap.map((k, v) {
    return MapEntry(ReCase(k).camelCase, v);
  });
  return {...parametersMap, ...camelCasedParametersMap};
}
