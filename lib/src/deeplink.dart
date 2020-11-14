import 'package:path_to_regexp/path_to_regexp.dart';
import 'package:recase/recase.dart';

class DeepLinkParser {
  DeepLinkParser(this.template, {this.prefix = false});

  final String template;
  final bool prefix;

  bool matches(String deepLink) {
    final regExp = pathToRegExp(template, prefix: prefix);
    return regExp.hasMatch(deepLink);
  }

  Map<String, String> extractArgs(String deepLink) {
    final parameters = <String>[];
    final regExp = pathToRegExp(template, parameters: parameters);
    final match = regExp.matchAsPrefix(deepLink);
    final parametersMap = extract(parameters, match)
      ..addAll(Uri.parse(deepLink).queryParameters);
    final camelCasedParametersMap = parametersMap.map((k, v) {
      return MapEntry(ReCase(k).camelCase, v);
    });
    return {...parametersMap, ...camelCasedParametersMap};
  }
}
