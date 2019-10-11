import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';

import 'helpers.dart';

class NavigationClass {
  NavigationClass(this.classElement);

  final ClassElement classElement;

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
    return Method(
      (f) => f
        ..name = '${lowerCamelCase(typeName)}Navigation'
        ..returns = refer('${typeName}Navigation')
        ..type = MethodType.getter
        ..lambda = true
        ..body = Code(
          '${typeName}Navigation(nuvigator)',
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

  Method _pushMethod(
      String className, String fieldName, String screenReturn, bool hasArgs) {
    final parameters = <Parameter>[];
    if (hasArgs) {
      parameters.add(
        Parameter(
          (p) => p
            ..name = 'arguments'
            ..type = refer('${capitalize(fieldName)}Args'),
        ),
      );
    }

    return Method(
      (m) => m
        ..name = fieldName
        ..returns = refer('Future<$screenReturn>')
        ..requiredParameters.addAll(parameters)
        ..body = Code(
          'return nuvigator.pushNamed<$screenReturn>(${className}Routes.$fieldName);',
        ),
    );
  }

  Method _subRouteMethod(String className) {
    return Method(
      (m) => m
        ..name = '${lowerCamelCase(className)}Navigation'
        ..returns = refer('${className}Navigation')
        ..type = MethodType.getter
        ..lambda = true
        ..body = Code(
          '${className}Navigation(nuvigator)',
        ),
    );
  }

  Class _generateNavigationClass(String className, List<Method> methods) {
    return Class(
      (b) => b
        ..name = '${className}Navigation'
        ..constructors.add(_constructor())
        ..fields.add(_nuvigatorStateField())
        ..methods.addAll(
          [
            _ofMethod('${className}Navigation'),
            ...methods,
          ],
        ),
    );
  }

  Class build() {
    final className = classElement.name;
    final methods = <Method>[];

    for (var field in classElement.fields) {
      final nuRouteFieldAnnotation =
          nuRouteChecker.firstAnnotationOfExact(field);
      final nuSubRouterAnnotation =
          nuSobRouterChecker.firstAnnotationOfExact(field);

      if (nuRouteFieldAnnotation != null) {
        final args = nuRouteFieldAnnotation?.getField('args')?.toMapValue();
        final subRouter =
            nuRouteFieldAnnotation?.getField('subRouter')?.toTypeValue();
        final screenReturn = getGenericTypes(field.type).toString();

        methods.add(
          _pushMethod(className, field.name, screenReturn, args != null),
        );

        if (subRouter != null) {
          methods.add(
            _subRouteMethod(subRouter.name),
          );
        }
      } else if (nuSubRouterAnnotation != null) {
        methods.add(
          _navigationMethod(field.type.name),
        );
      }
    }

    return _generateNavigationClass(className, methods);
  }
}
