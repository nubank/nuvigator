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
    final navigationName = '${removeRouterKey(typeName)}Navigation';
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

  String _getArgs(List<Parameter> parameters, MethodElement method) {
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
    return argumentsMapBuffer.toString();
  }

  Method _pushMethod(
      String className, String screenReturn, MethodElement method) {
    final parameters = <Parameter>[];
    final args = _getArgs(parameters, method);
    final hasParameters = parameters.isNotEmpty;
    final routeName = '${removeRouterKey(className)}Routes.${method.name}';

    return Method(
      (m) => m
        ..name = 'to${capitalize(method.name)}'
        ..returns = refer('Future<$screenReturn>')
        ..optionalParameters.addAll(parameters)
        ..body = hasParameters
            ? Code(
                'return nuvigator.pushNamed<$screenReturn>($routeName, arguments: $args,);',
              )
            : Code(
                'return nuvigator.pushNamed<$screenReturn>($routeName,);',
              ),
    );
  }

  Method _pushReplacementMethod(
      String className, String screenReturn, MethodElement method) {
    final parameters = <Parameter>[];
    final args = _getArgs(parameters, method);
    final hasParameters = parameters.isNotEmpty;
    final routeName = '${removeRouterKey(className)}Routes.${method.name}';

    parameters.add(
      Parameter(
        (p) => p
          ..name = 'result'
          ..named = true
          ..type = refer('TO'),
      ),
    );

    return Method(
      (m) => m
        ..name = 'pushReplacementTo${capitalize(method.name)}'
        ..returns = refer('Future<$screenReturn>')
        ..optionalParameters.addAll([
          ...parameters,
        ])
        ..types.add(refer('TO extends Object'))
        ..body = hasParameters
            ? Code(
                'return nuvigator.pushReplacementNamed<$screenReturn, TO>($routeName, arguments: $args, result: result,);',
              )
            : Code(
                'return nuvigator.pushReplacementNamed<$screenReturn, TO>($routeName, result: result,);',
              ),
    );
  }

  Method _pushAndRemoveUntilMethod(
      String className, String screenReturn, MethodElement method) {
    final parameters = <Parameter>[];
    final args = _getArgs(parameters, method);
    final hasParameters = parameters.isNotEmpty;
    final routeName = '${removeRouterKey(className)}Routes.${method.name}';

    parameters.add(
      Parameter(
        (p) => p
          ..name = 'predicate'
          ..named = true
          ..annotations.add(const CodeExpression(Code('required')))
          ..type = refer('RoutePredicate'),
      ),
    );

    return Method(
      (m) => m
        ..name = 'pushAndRemoveUntilTo${capitalize(method.name)}'
        ..returns = refer('Future<$screenReturn>')
        ..optionalParameters.addAll([
          ...parameters,
        ])
        ..types.add(refer('TO extends Object'))
        ..body = hasParameters
            ? Code(
                'return nuvigator.pushNamedAndRemoveUntil<$screenReturn>($routeName, predicate, arguments: $args,);',
              )
            : Code(
                'return nuvigator.pushNamedAndRemoveUntil<$screenReturn>($routeName, predicate,);',
              ),
    );
  }

  Method _popAndPushMethod(
      String className, String screenReturn, MethodElement method) {
    final parameters = <Parameter>[];
    final args = _getArgs(parameters, method);
    final hasParameters = parameters.isNotEmpty;
    final routeName = '${removeRouterKey(className)}Routes.${method.name}';

    parameters.add(
      Parameter(
        (p) => p
          ..name = 'result'
          ..named = true
          ..type = refer('TO'),
      ),
    );

    return Method(
      (m) => m
        ..name = 'popAndPushTo${capitalize(method.name)}'
        ..returns = refer('Future<$screenReturn>')
        ..optionalParameters.addAll([
          ...parameters,
        ])
        ..types.add(refer('TO extends Object'))
        ..body = hasParameters
            ? Code(
                'return nuvigator.popAndPushNamed<$screenReturn, TO>($routeName, arguments: $args, result: result,);',
              )
            : Code(
                'return nuvigator.popAndPushNamed<$screenReturn, TO>($routeName, result: result,);',
              ),
    );
  }

  Method _subRouterMethod(String className) {
    final name = removeRouterKey(className);
    return Method(
      (m) => m
        ..name = '${lowerCamelCase(name)}Navigation'
        ..returns = refer('${name}Navigation')
        ..type = MethodType.getter
        ..lambda = true
        ..body = Code(
          '${name}Navigation(nuvigator)',
        ),
    );
  }

  Class _generateNavigationClass(String className, List<Method> methods) {
    final navigationClassName = '${removeRouterKey(className)}Navigation';
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

  void checkPushMethodsAndAdd(
      List<Method> methods, String className, MethodElement method) {
    final nuRouteFieldAnnotation =
        nuRouteChecker.firstAnnotationOf(method, throwOnUnresolved: true);

    if (nuRouteFieldAnnotation != null) {
      final generics = getGenericTypes(method.returnType);
      final screenReturn =
          generics.length > 1 ? generics[1].name : generics.first.name;
      final pushMethods =
          nuRouteFieldAnnotation.getField('pushMethods').toListValue();
      if (pushMethods != null) {
        for (final pushMethod in pushMethods) {
          final pushStr = pushMethod.toString();
          if (pushStr.contains('push =')) {
            methods.add(_pushMethod(className, screenReturn, method));
          } else if (pushStr.contains('pushReplacement =')) {
            methods
                .add(_pushReplacementMethod(className, screenReturn, method));
          } else if (pushStr.contains('popAndPush =')) {
            methods.add(_popAndPushMethod(className, screenReturn, method));
          } else if (pushStr.contains('pushAndRemoveUntil =')) {
            methods.add(
                _pushAndRemoveUntilMethod(className, screenReturn, method));
          }
        }
      } else {
        methods.addAll([
          _pushMethod(className, screenReturn, method),
          _pushReplacementMethod(className, screenReturn, method),
          _pushAndRemoveUntilMethod(className, screenReturn, method),
          _popAndPushMethod(className, screenReturn, method),
        ]);
      }
    }
  }

  @override
  Spec build() {
    final className = getRouterName(classElement);
    final methods = <Method>[];

    for (final method in classElement.methods) {
      checkPushMethodsAndAdd(methods, className, method);

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
          _navigationMethod(getRouterName(field)),
        );
      }
    }

    return _generateNavigationClass(className, methods);
  }
}
