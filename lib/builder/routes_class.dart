import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';

import 'helpers.dart';

class RoutesClass {
  RoutesClass(this.classElement);

  final ClassElement classElement;

  Class _generateRoutesClass(String className, List<Field> fields) {
    return Class(
      (b) => b
        ..name = '${className}Routes'
        ..fields.addAll(fields),
    );
  }

  Field _constRoutesField(String fieldName, String className) {
    return Field(
      (f) => f
        ..name = fieldName
        ..assignment = Code("'$className/$fieldName'")
        ..modifier = FieldModifier.constant
        ..static = true,
    );
  }

  Class build() {
    final className = classElement.name;

    final fields = classElement.fields
        .where((field) => nuRouteChecker.firstAnnotationOfExact(field) != null)
        .map((field) => _constRoutesField(field.name, className))
        .toList();

    return _generateRoutesClass(className, fields);
  }
}
