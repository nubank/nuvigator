import 'dart:async';

import 'package:build/build.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/type.dart';

class NuRouter {
  const NuRouter();
}

const nuRouter = NuRouter();

class NuSubRouter {
  const NuSubRouter();
}

const nuSubRouter = NuSubRouter();

class NuRoute {
  const NuRoute({this.args, this.subRouter});

  final Map<String, Type> args;
  final Type subRouter;
}

DartType getGenericTypes(DartType type) {
  return type is ParameterizedType ? type.typeArguments.first : null;
}

const _nuRouteChecker = TypeChecker.fromRuntime(NuRoute);
const _nuSobRouterChecker = TypeChecker.fromRuntime(NuSubRouter);

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

String lowerCamelCase(String s) => s[0].toLowerCase() + s.substring(1);

class NuvigationGenerator extends GeneratorForAnnotation<NuRouter> {
  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    final buffer = StringBuffer();
    final screensMapBuffer = StringBuffer();
    final subRoutersListBuffer = StringBuffer();
    final navigationBuffer = StringBuffer();
    final argsClassesBuffer = StringBuffer();
    final ClassElement classElement = element;
//    buffer.write("import 'package:nuvigator/nuvigator.dart';\n");
//    buffer.write("import 'package:flutter/widgets.dart';\n");
//    buffer.write("import '${classElement.source.shortName}';\n\n");
    buffer.write('class ${classElement.name}Routes {\n');
    screensMapBuffer.write(
        'Map<String, Screen> ${lowerCamelCase(classElement.name)}\$getScreensMap(${classElement.name} router) {\n'
        'return {\n');
    subRoutersListBuffer.write(
        'List<Router> ${lowerCamelCase(classElement.name)}\$getSubRoutersList(${classElement.name} router) {\n'
        'return [\n');
    navigationBuffer.write('class ${classElement.name}Navigation {\n'
        '${classElement.name}Navigation(this.nuvigator);\n\n'
        'static ${classElement.name}Navigation of(BuildContext context) => ${classElement.name}Navigation(Nuvigator.of(context));\n\n'
        'final NuvigatorState nuvigator;\n\n');
    for (final field in classElement.fields) {
      String navigationFnParams = '';
      final nuRouteFieldAnnotation =
          _nuRouteChecker.firstAnnotationOfExact(field);
      final nuSubRouterAnnotation =
          _nuSobRouterChecker.firstAnnotationOfExact(field);
      if (nuRouteFieldAnnotation != null) {
        final argsBuffer = StringBuffer();
        final args = nuRouteFieldAnnotation?.getField('args')?.toMapValue();
        final subRouter =
            nuRouteFieldAnnotation?.getField('subRouter')?.toTypeValue();
        if (args != null) {
          final argsFieldsBuffer = StringBuffer();
          final argsParserBuffer = StringBuffer();
          final argsClassName = '${capitalize(field.name)}Args';
          argsClassesBuffer.write('class $argsClassName {\n'
              '${capitalize(field.name)}Args(');

          argsBuffer.write('{');
          for (final argEntry in args.entries) {
            final typeName = argEntry.value.toTypeValue().name;
            final varName = argEntry.key.toStringValue();
            argsBuffer.write('@required this.$varName,');
            argsParserBuffer.write("$varName: args['$varName'],\n");
            argsFieldsBuffer.write('final $typeName $varName;\n');
          }
          argsBuffer.write('}');

          argsClassesBuffer.write(argsBuffer.toString());
          argsClassesBuffer.write(');\n\n');
          argsClassesBuffer.write(argsFieldsBuffer.toString());

          argsClassesBuffer.write(
              '\nstatic $argsClassName parse(Map<String, String> args) {\n'
              'return $argsClassName(${argsParserBuffer.toString()});');

          argsClassesBuffer.write('\n}\n');

          argsClassesBuffer.write('\n}\n\n');
          navigationFnParams = '$argsClassName arguments';
        }
        final screenReturn = getGenericTypes(field.type);
        buffer.write(
            'static const ${field.name} = \'${classElement.name}/${field.name}\';\n');
        screensMapBuffer.write(
            '${classElement.name}Routes.${field.name}: router.${field.name},\n');
        navigationBuffer.write(
            'Future<$screenReturn> ${field.name}($navigationFnParams) {\n'
            'return nuvigator.pushNamed<$screenReturn>(${classElement.name}Routes.${field.name});'
            '\n}\n');

        if (subRouter != null) {
          navigationBuffer.write(
              '${subRouter.name}Navigation get ${lowerCamelCase(subRouter.name)}Navigation => ${subRouter.name}Navigation(nuvigator);\n');
        }
      } else if (nuSubRouterAnnotation != null) {
        subRoutersListBuffer.write('router.${field.name},\n');
        navigationBuffer.write(
            '${field.type.name}Navigation get ${lowerCamelCase(field.name)}Navigation => ${field.type.name}Navigation(nuvigator);\n');
      }
    }
    buffer.write('\n}');
    navigationBuffer.write('\n}');
    screensMapBuffer.write('\n};\n}');
    subRoutersListBuffer.write('\n];\n}');
    return buffer.toString() +
        '\n' +
        argsClassesBuffer.toString() +
        '\n' +
        screensMapBuffer.toString() +
        '\n' +
        subRoutersListBuffer.toString() +
        '\n' +
        navigationBuffer.toString();
  }
}

Builder nuvigationBuilder(BuilderOptions options) =>
    PartBuilder([NuvigationGenerator()], '.nuvigation.g.dart');
