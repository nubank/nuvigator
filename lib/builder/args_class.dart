import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:nuvigator/builder/base_builder.dart';

import 'helpers.dart';

class ArgsClass extends BaseBuilder {
  ArgsClass(ClassElement classElement) : super(classElement);

  Constructor _constructor(List<Parameter> parameters) {
    return Constructor(
      (c) => c..optionalParameters.addAll(parameters),
    );
  }

  Parameter _constructorParameter(String name) {
    return Parameter(
      (p) => p
        ..name = name
        ..named = true
        ..annotations.add(
          refer('required'),
        )
        ..toThis = true,
    );
  }

  Field _argsField(String name, String typeName) {
    return Field(
      (m) => m
        ..name = name
        ..type = refer(typeName)
        ..modifier = FieldModifier.final$,
    );
  }

  Method _parseMethod(String className, String argsCode) {
    return Method(
      (m) => m
        ..name = 'parse'
        ..requiredParameters.add(
          Parameter((p) => p
            ..name = 'args'
            ..type = refer('Map<String, Object>')),
        )
        ..returns = refer(className)
        ..static = true
        ..body = Code('return $className($argsCode);'),
    );
  }

  Method _ofMethod(String className, String routerName, String screenName) {
    return Method(
      (m) => m
        ..name = 'of'
        ..static = true
        ..returns = refer(className)
        ..requiredParameters.add(
          Parameter(
            (p) => p
              ..name = 'context'
              ..type = refer('BuildContext'),
          ),
        )
        ..body = Code(
          'final routeSettings = ModalRoute.of(context)?.settings;'
          'final nuvigator = Nuvigator.of(context);'
          'if (routeSettings?.name == _${routerName}Routes.$screenName) {'
          'final args = routeSettings?.arguments;'
          'if (args == null) throw FlutterError(\'$className requires Route arguments\');'
          'if (args is $className) return args;'
          'if (args is Map<String, Object>) return parse(args);'
          '} else if (nuvigator != null) {'
          'return of(nuvigator.context);'
          '}'
          'return null;',
        ),
    );
  }

  Method _toMapMethod(List<Field> argsFields) {
    final argsMap = StringBuffer('{\n');
    for (final field in argsFields) {
      argsMap.write('\'${field.name}\': ${field.name},');
    }
    argsMap.write('}');
    return Method((m) => m
      ..name = 'toMap'
      ..type = MethodType.getter
      ..returns = refer('Map<String, Object>')
      ..lambda = true
      ..body = Code(argsMap.toString()));
  }

  Class _generateArgsClass(String routerName, String fieldName, String argsCode,
      List<Parameter> constructorParameters, List<Field> argsFields) {
    final className = '${capitalize(fieldName)}Args';
    return Class(
      (c) => c
        ..name = className
        ..constructors.add(_constructor(constructorParameters))
        ..fields.addAll(argsFields)
        ..methods.addAll([
          _parseMethod(className, argsCode),
          _toMapMethod(argsFields),
          _ofMethod(className, routerName, fieldName),
        ]),
    );
  }

  @override
  Spec build() {
    final argsClasses = <Class>[];

    for (var method in classElement.methods) {
      final nuRouteFieldAnnotation =
          nuRouteChecker.firstAnnotationOfExact(method);

      if (nuRouteFieldAnnotation == null ||
          method?.parameters == null ||
          method.parameters.isEmpty) continue;

      final constructorParameters = <Parameter>[];
      final argsFields = <Field>[];
      final argsParserBuffer = StringBuffer('');

      for (final arg in method.parameters) {
        final varName = arg.name.toString();
        final typeName = arg.type.toString();

        argsParserBuffer.write("$varName: args['$varName'],\n");

        constructorParameters.add(
          _constructorParameter(varName),
        );

        argsFields.add(
          _argsField(varName, typeName),
        );
      }

      argsClasses.add(
        _generateArgsClass(
          removeRouterKey(getRouterName(classElement)),
          method.name,
          argsParserBuffer.toString(),
          constructorParameters,
          argsFields,
        ),
      );
    }

    return Library((l) => l.body..addAll(argsClasses));
  }
}
