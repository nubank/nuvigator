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
          'if (routeSettings?.name == ${routerName}Routes.$screenName) {'
          'final args = routeSettings?.arguments;'
          'if (args is $className) return args;'
          'if (args is Map<String, Object>) return parse(args);'
          '} else if (nuvigator != null) {'
          'return of(nuvigator.context);'
          '}'
          'return null;',
        ),
    );
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
          _ofMethod(className, routerName, fieldName),
        ]),
    );
  }

  Class _generateScreenClass(ClassElement classElement, String routeName) {
    final routerNavigationName = '${getRouterName(classElement)}Navigation';

    return Class(
      (c) => c
        ..name = '${routeName}Screen'
        ..abstract = true
        ..extend = refer('ScreenWidget')
        ..constructors.add(
          Constructor((cons) => cons
            ..initializers.add(const Code('super(context)'))
            ..requiredParameters.add(
              Parameter(
                (p) => p
                  ..type = refer('BuildContext')
                  ..name = 'context',
              ),
            )),
        )
        ..methods.addAll([
          Method(
            (m) => m
              ..name = 'args'
              ..lambda = true
              ..type = MethodType.getter
              ..returns = refer('${capitalize(routeName)}Args')
              ..body = Code('${capitalize(routeName)}Args.of(context)'),
          ),
          Method(
            (m) => m
              ..name = lowerCamelCase(routerNavigationName)
              ..lambda = true
              ..type = MethodType.getter
              ..returns = refer(capitalize(routerNavigationName))
              ..body = Code('${capitalize(routerNavigationName)}.of(context)'),
          ),
        ]),
    );
  }

  @override
  Spec build() {
    final argsClasses = <Class>[];
    final screensClasses = <Class>[];

    for (var method in classElement.methods) {
      final nuRouteFieldAnnotation =
          nuRouteChecker.firstAnnotationOfExact(method);
      final isFlow = method.type.name == 'FlowRoute';

      if (nuRouteFieldAnnotation == null) continue;

//      final args = nuRouteFieldAnnotation?.getField('args')?.toFunctionValue();

      if (method?.parameters == null || method.parameters.isEmpty) continue;

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
      if (!isFlow) {
        screensClasses.add(
          _generateScreenClass(
            classElement,
            capitalize(method.name),
          ),
        );
      }
    }

    return Library((l) => l.body..addAll(argsClasses)..addAll(screensClasses));
  }
}
