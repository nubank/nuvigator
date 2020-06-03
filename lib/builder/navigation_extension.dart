import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:nuvigator/builder/base_builder.dart';

import 'helpers.dart';

class NavigationExtension extends BaseBuilder {
  NavigationExtension(ClassElement classElement) : super(classElement);

  String _getArgs(
      List<Parameter> parameters, MethodElement method, bool isPrefix) {
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
              ..annotations.addAll(isRequired ? [refer('required')] : [])
              ..named = true
              ..type = refer(arg.type.toString()),
          ),
        );
        argumentsMapBuffer.write("'$argName': $argName,");
      }
    }
    if (isPrefix) {
      parameters.add(Parameter((p) => p
        ..name = 'path'
        ..annotations.add(refer('required'))
        ..named = true
        ..type = refer('String')));
    }
    argumentsMapBuffer.write('}');
    return argumentsMapBuffer.toString();
  }

  Method _pushMethod(String routeName, String screenReturn,
      MethodElement method, bool isPrefix) {
    final parameters = <Parameter>[];
    final args = _getArgs(parameters, method, isPrefix);
    final hasParameters = parameters.isNotEmpty;

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

  Method _pushReplacementMethod(String routeName, String screenReturn,
      MethodElement method, bool isPrefix) {
    final parameters = <Parameter>[];
    final args = _getArgs(parameters, method, isPrefix);
    final hasParameters = parameters.isNotEmpty;

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

  Method _pushAndRemoveUntilMethod(String routeName, String screenReturn,
      MethodElement method, bool isPrefix) {
    final parameters = <Parameter>[];
    final args = _getArgs(parameters, method, isPrefix);
    final hasParameters = parameters.isNotEmpty;

    parameters.add(
      Parameter(
        (p) => p
          ..name = 'predicate'
          ..named = true
          ..annotations.add(refer('required'))
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

  Method _popAndPushMethod(String routeName, String screenReturn,
      MethodElement method, bool isPrefix) {
    final parameters = <Parameter>[];
    final args = _getArgs(parameters, method, isPrefix);
    final hasParameters = parameters.isNotEmpty;

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
    return Method(
      (m) => m
        ..name = '${lowerCamelCase(className)}'
        ..returns = refer(className)
        ..type = MethodType.getter
        ..lambda = true
        ..body = Code(
          'getRouter<$className>()',
        ),
    );
  }

  Method _getDeepLinkMethod(
      String deepLink, MethodElement method, bool isPrefix) {
    final parameters = <Parameter>[];
    final args = _getArgs(parameters, method, isPrefix);
    return Method(
      (m) => m
        ..name = '${method.name}DeepLink'
        ..returns = refer('String')
        ..optionalParameters.addAll(parameters)
        ..body = Code('encodeDeepLink($deepLink, <String, dynamic>$args)')
        ..lambda = true,
    );
  }

  void checkPushMethodsAndAdd(
      List<Method> methods, String className, MethodElement method) {
    final nuRouteFieldAnnotation =
        nuRouteChecker.firstAnnotationOf(method, throwOnUnresolved: true);
    if (nuRouteFieldAnnotation != null) {
      final isPrefix = nuRouteFieldAnnotation.getField('prefix')?.toBoolValue();
      final extraPath = isPrefix ? ' + path' : '';
      final routeName =
          'pathWithPrefix(${removeRouterKey(className)}Routes.${method.name})$extraPath';
      methods.add(_getDeepLinkMethod(routeName, method, isPrefix));
      final generics = getGenericTypes(method.returnType);
      final screenReturn =
          generics.length > 1 ? generics[1].name : generics.first.name;
      final pushMethods =
          nuRouteFieldAnnotation.getField('pushMethods').toListValue();
      if (pushMethods != null) {
        for (final pushMethod in pushMethods) {
          final pushStr = pushMethod.toString();
          if (pushStr.contains('push =')) {
            methods.add(_pushMethod(routeName, screenReturn, method, isPrefix));
          } else if (pushStr.contains('pushReplacement =')) {
            methods.add(_pushReplacementMethod(
                routeName, screenReturn, method, isPrefix));
          } else if (pushStr.contains('popAndPush =')) {
            methods.add(
                _popAndPushMethod(routeName, screenReturn, method, isPrefix));
          } else if (pushStr.contains('pushAndRemoveUntil =')) {
            methods.add(_pushAndRemoveUntilMethod(
                routeName, screenReturn, method, isPrefix));
          }
        }
      } else {
        methods.addAll([
          _pushMethod(routeName, screenReturn, method, isPrefix),
          _pushReplacementMethod(routeName, screenReturn, method, isPrefix),
          _pushAndRemoveUntilMethod(routeName, screenReturn, method, isPrefix),
          _popAndPushMethod(routeName, screenReturn, method, isPrefix),
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
    }

    for (final field in classElement.fields) {
      final nuSubRouterAnnotation =
          nuRouterChecker.firstAnnotationOfExact(field);
      if (nuSubRouterAnnotation != null) {
        methods.add(
          _subRouterMethod(field.type.name),
        );
      }
    }

    final library = Library((l) => l.body..addAll(methods));

    final code =
        'extension ${classElement.name}Navigation on ${classElement.name} {\n ${libraryToString(library)} \n}';

    return Code(code);
  }
}
