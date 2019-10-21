import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:nuvigator/builder/base_builder.dart';
import 'package:nuvigator/builder/routes_class.dart';

import 'args_class.dart';
import 'helpers.dart';
import 'navigation_class.dart';

class BuilderLibrary extends BaseBuilder {
  BuilderLibrary(ClassElement classElement) : super(classElement);

  Method _screensMapMethod(String className, String code) {
    final lowerClassName = lowerCamelCase(className);

    return Method(
      (b) => b
        ..body = const Code('')
        ..name = '_\$${routerName(lowerClassName)}ScreensMap'
        ..requiredParameters.add(
          Parameter(
            (p) => p
              ..type = refer(className)
              ..name = 'router',
          ),
        )
        ..returns = refer('Map<RouteDef, ScreenRouteBuilder>')
        ..body = Code('return {$code};'),
    );
  }

  Method _subRoutersListMethod(String className, String code) {
    final lowerClassName = lowerCamelCase(className);

    return Method(
      (b) => b
        ..name = '_\$${routerName(lowerClassName)}RoutersList'
        ..requiredParameters.add(
          Parameter(
            (p) => p
              ..type = refer(className)
              ..name = 'router',
          ),
        )
        ..returns = refer('List<Router>')
        ..lambda = true
        ..body = Code('[$code]'),
    );
  }

  Library _generateLibrary(
      String className, String screensMapCode, String subRoutersListCode) {
    return Library(
      (l) => l
        ..body.addAll([
          RoutesClass(classElement).build(),
          ArgsClass(classElement).build(),
          NavigationClass(classElement).build(),
          _screensMapMethod(className, screensMapCode),
          if (subRoutersListCode != '')
            _subRoutersListMethod(className, subRoutersListCode),
        ]),
    );
  }

  @override
  Spec build() {
    final className = classElement.name;

    final screensMapBuffer = StringBuffer();
    final subRoutersListBuffer = StringBuffer();

    for (final method in classElement.methods) {
      final nuRouteFieldAnnotation =
          nuRouteChecker.firstAnnotationOfExact(method);
      if (nuRouteFieldAnnotation != null) {
        final params = method.parameters.map((p) => p.name);
        final deepLink =
            nuRouteFieldAnnotation.getField('deepLink').toStringValue();
        final paramsStr = params.isEmpty
            ? ''
            : '${params.map((p) => "$p: args['$p']").join(",")}';

        final screenRouteBuilder = Method((m) => m
          ..requiredParameters.add(Parameter((p) => p
            ..name = 'settings'
            ..type = refer('RouteSettings')))
          ..lambda = false
          ..body = Code((params.isEmpty
                  ? ''
                  : 'final Map<String, Object> args = settings.arguments;') +
              'return router.${method.name}($paramsStr);'));

        if (deepLink != null) {
          screensMapBuffer.write(
              'RouteDef(${routerName(className)}Routes.${method.name}, deepLink: \'$deepLink\'): ${screenRouteBuilder.accept(DartEmitter())},\n');
        } else {
          screensMapBuffer.write(
              'RouteDef(${routerName(className)}Routes.${method.name}): ${screenRouteBuilder.accept(DartEmitter())},\n');
        }
      }
    }

    for (final field in classElement.fields) {
      final nuSubRouterAnnotation =
          nuRouterChecker.firstAnnotationOfExact(field);
      if (nuSubRouterAnnotation != null) {
        subRoutersListBuffer.write('router.${field.name},\n');
      }
    }

    return _generateLibrary(
      className,
      screensMapBuffer.toString(),
      subRoutersListBuffer.toString(),
    );
  }
}
