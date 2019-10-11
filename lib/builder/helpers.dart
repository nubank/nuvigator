import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';

import '../builder.dart';

DartType getGenericTypes(DartType type) {
  return type is ParameterizedType ? type.typeArguments.first : null;
}

const nuRouteChecker = TypeChecker.fromRuntime(NuRoute);
const nuSobRouterChecker = TypeChecker.fromRuntime(NuSubRouter);

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
String lowerCamelCase(String s) => s[0].toLowerCase() + s.substring(1);
