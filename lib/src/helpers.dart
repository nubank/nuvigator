import 'package:path_to_regexp/path_to_regexp.dart';
import 'package:recase/recase.dart';

RegExp pathToRegex(String path, {List<String> parameters}) {
  final prefix = path.endsWith('*');
  if (prefix) {
    return pathToRegExp(path.substring(0, path.length - 1),
        parameters: parameters, prefix: true);
  } else {
    return pathToRegExp(path, parameters: parameters);
  }
}

Map<String, String> extractDeepLinkParameters(String deepLink, String path) {
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
