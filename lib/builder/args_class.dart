import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';

import 'helpers.dart';

class ArgsClass {
  ArgsClass(this.classElement);

  final ClassElement classElement;

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
          const CodeExpression(
            Code('required'),
          ),
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
            ..type = refer('Map<String, String>')),
        )
        ..returns = refer(className)
        ..static = true
        ..body = Code('return $className($argsCode);'),
    );
  }

  Method _ofMethod(String className) {
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
          'final args = ModalRoute.of(context)?.settings?.arguments;'
          'if (args is $className) return args;'
          'if (args is Map<String, String>) return parse(args);'
          'return null;',
        ),
    );
  }

  Class _generateArgsClass(String className, String argsCode,
      List<Parameter> constructorParameters, List<Field> argsFields) {
    return Class(
      (c) => c
        ..name = className
        ..constructors.add(_constructor(constructorParameters))
        ..fields.addAll(argsFields)
        ..methods.addAll([
          _parseMethod(className, argsCode),
          _ofMethod(className),
        ]),
    );
  }

  List<Class> build() {
    final className = classElement.name;
    final argsClasses = <Class>[];

    for (var field in classElement.fields) {
      final nuRouteFieldAnnotation =
          nuRouteChecker.firstAnnotationOfExact(field);

      if (nuRouteFieldAnnotation == null) continue;

      final args = nuRouteFieldAnnotation?.getField('args')?.toMapValue();

      if (args == null) continue;

      final constructorParameters = <Parameter>[];
      final argsFields = <Field>[];
      final argsParserBuffer = StringBuffer('');

      for (final argEntry in args.entries) {
        final varName = argEntry.key.toStringValue();
        final typeName = argEntry.value.toTypeValue().name;

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
          '${capitalize(field.name)}Args',
          argsParserBuffer.toString(),
          constructorParameters,
          argsFields,
        ),
      );
    }

    return argsClasses;
  }
}
