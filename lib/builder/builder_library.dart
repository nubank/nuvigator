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
        ..returns = refer('Map<String, ScreenRoute>')
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
          _subRoutersListMethod(className, subRoutersListCode),
        ]),
    );
  }

  @override
  Spec build() {
    final className = classElement.name;

    final screensMapBuffer = StringBuffer();
    final subRoutersListBuffer = StringBuffer();

    for (final field in classElement.fields) {
      final nuRouteFieldAnnotation =
          nuRouteChecker.firstAnnotationOfExact(field);
      final nuSubRouterAnnotation =
          nuRouterChecker.firstAnnotationOfExact(field);

      if (nuRouteFieldAnnotation != null) {
        screensMapBuffer.write(
            '${routerName(className)}Routes.${field.name}: router.${field.name},\n');
      } else if (nuSubRouterAnnotation != null) {
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
