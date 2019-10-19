import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:nuvigator/builder/base_builder.dart';

import 'helpers.dart';

class RoutesClass extends BaseBuilder {
  RoutesClass(ClassElement classElement) : super(classElement);

  Class _generateRoutesClass(String className, List<Field> fields) {
    return Class(
      (b) => b
        ..name = '${routerName(className)}Routes'
        ..fields.addAll(fields),
    );
  }

  Field _constRoutesField(String fieldName, String className) {
    return Field(
      (f) => f
        ..name = fieldName
        ..assignment = Code("'${routerName(className)}/$fieldName'")
        ..modifier = FieldModifier.constant
        ..static = true,
    );
  }

  @override
  Spec build() {
    final className = classElement.name;

    final fields = classElement.methods
        .where((m) => nuRouteChecker.firstAnnotationOfExact(m) != null)
        .map((method) => _constRoutesField(method.name, className))
        .toList();

    return _generateRoutesClass(className, fields);
  }
}
