import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:nuvigator/builder/base_builder.dart';

import 'helpers.dart';

class RoutesClass extends BaseBuilder {
  RoutesClass(ClassElement classElement) : super(classElement);

  Class _generateRoutesClass(ClassElement classElement, List<Field> fields) {
    return Class(
      (b) => b
        ..name = '_${getRouterName(classElement)}Routes'
        ..fields.addAll(fields),
    );
  }

  Field _constRoutesField(MethodElement routeMethod, ClassElement routerClass) {
    return Field(
      (f) => f
        ..name = routeMethod.name
        ..assignment = Code("'${getRouteString(routerClass, routeMethod)}'")
        ..modifier = FieldModifier.constant
        ..static = true,
    );
  }

  @override
  Spec build() {
    final fields = classElement.methods
        .where((m) => nuRouteChecker.firstAnnotationOfExact(m) != null)
        .map((method) => _constRoutesField(method, classElement))
        .toList();

    return _generateRoutesClass(classElement, fields);
  }
}
