import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:nuvigator/src/annotations.dart';
import 'package:source_gen/source_gen.dart';

List<DartType> getGenericTypes(DartType type) {
  return type is ParameterizedType ? type.typeArguments : null;
}

const nuRouteChecker = TypeChecker.fromRuntime(NuRoute);
const nuRouterChecker = TypeChecker.fromRuntime(NuRouter);

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

String lowerCamelCase(String s) => s[0].toLowerCase() + s.substring(1);

String removeRouterKey(String routerClassName) =>
    routerClassName.replaceAll('Router', '');

String getRouterName(Element element) {
  final name = nuRouterChecker
          .firstAnnotationOfExact(element)
          ?.getField('routerName')
          ?.toStringValue() ??
      removeRouterKey(element.name);
  return capitalize(name);
}

String getRouteString(ClassElement routerElement, MethodElement element) {
  final routeName = nuRouteChecker
          .firstAnnotationOfExact(element)
          ?.getField('deepLink')
          ?.toStringValue() ??
      element.name;

  return routeName;
}

String libraryToString(Library library) {
  final emitter = DartEmitter(Allocator.simplePrefixing());
  return DartFormatter().format('${library.accept(emitter)}');
}
