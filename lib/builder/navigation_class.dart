import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:nuvigator/builder/base_builder.dart';

import 'helpers.dart';

class NavigationClass extends BaseBuilder {
  NavigationClass(ClassElement classElement) : super(classElement);

  Constructor _constructor() {
    return Constructor(
      (c) => c
        ..requiredParameters.add(
          Parameter(
            (p) => p
              ..name = 'nuvigator'
              ..toThis = true,
          ),
        ),
    );
  }

  Field _nuvigatorStateField() {
    return Field(
      (f) => f
        ..name = 'nuvigator'
        ..type = refer('NuvigatorState')
        ..modifier = FieldModifier.final$,
    );
  }

  Method _navigationMethod(String typeName) {
    final navigationName = '${routerName(typeName)}Navigation';
    return Method(
      (f) => f
        ..name = '${lowerCamelCase(navigationName)}'
        ..returns = refer(navigationName)
        ..type = MethodType.getter
        ..lambda = true
        ..body = Code(
          '$navigationName(nuvigator)',
        ),
    );
  }

  Method _ofMethod(String className) {
    return Method(
      (m) => m
        ..name = 'of'
        ..requiredParameters.add(
          Parameter(
            (p) => p
              ..name = 'context'
              ..type = refer('BuildContext'),
          ),
        )
        ..returns = refer(className)
        ..body = Code('$className(Nuvigator.of(context))')
        ..lambda = true
        ..static = true,
    );
  }

  Method _pushMethod(String className, String fieldName, String screenReturn,
      MethodElement method) {
    final parameters = <Parameter>[];
    final argumentsMapBuffer = StringBuffer('{');
    final hasParameters =
        method?.parameters != null && method.parameters.isNotEmpty;

    if (hasParameters) {
      for (final arg in method.parameters) {
        final argName = arg.name.toString();
        final isRequired = arg.metadata.isNotEmpty &&
            arg.metadata.firstWhere((e) => e.isRequired, orElse: null) != null;
        parameters.add(
          Parameter(
            (p) => p
              ..name = argName
              ..annotations.addAll(
                  isRequired ? [const CodeExpression(Code('required'))] : [])
              ..named = true
              ..type = refer(arg.type.toString()),
          ),
        );
        argumentsMapBuffer.write("'$argName': $argName,");
      }
    }
    argumentsMapBuffer.write('}');

    final routeName = '${routerName(className)}Routes.$fieldName';

    return Method(
      (m) => m
        ..name = fieldName
        ..returns = refer('Future<$screenReturn>')
        ..optionalParameters.addAll(parameters)
        ..body = hasParameters
            ? Code(
                'return nuvigator.pushNamed<$screenReturn>($routeName, arguments: ${argumentsMapBuffer.toString()});',
              )
            : Code(
                'return nuvigator.pushNamed<$screenReturn>($routeName);',
              ),
    );
  }

  Method _subRouterMethod(String className) {
    return Method(
      (m) => m
        ..name = '${routerName(lowerCamelCase(className))}Navigation'
        ..returns = refer('${routerName(className)}Navigation')
        ..type = MethodType.getter
        ..lambda = true
        ..body = Code(
          '${routerName(className)}Navigation(nuvigator)',
        ),
    );
  }

  Class _generateNavigationClass(String className, List<Method> methods) {
    final navigationClassName = '${routerName(className)}Navigation';
    return Class(
      (b) => b
        ..name = navigationClassName
        ..constructors.add(_constructor())
        ..fields.add(_nuvigatorStateField())
        ..methods.addAll(
          [
            _ofMethod(navigationClassName),
            ...methods,
          ],
        ),
    );
  }

  @override
  Spec build() {
    final className = classElement.name;
    final methods = <Method>[];

    for (final method in classElement.methods) {
      final nuRouteFieldAnnotation =
          nuRouteChecker.firstAnnotationOf(method, throwOnUnresolved: true);

      if (nuRouteFieldAnnotation != null) {
        final generics = getGenericTypes(method.returnType);
        final screenReturn =
            generics.length > 1 ? generics[1].name : generics.first.name;

        methods.add(
          _pushMethod(className, method.name, screenReturn, method),
        );
      }
      final isFlow = method.returnType.name == 'FlowRoute';
      if (isFlow) {
        final subRouter = getGenericTypes(method.returnType).first;
        methods.add(
          _subRouterMethod(subRouter.name),
        );
      }
    }

    for (final field in classElement.fields) {
      final nuSubRouterAnnotation =
          nuRouterChecker.firstAnnotationOfExact(field);
      if (nuSubRouterAnnotation != null) {
        methods.add(
          _navigationMethod(field.type.name),
        );
      }
    }

    return _generateNavigationClass(className, methods);
  }
}
