import 'package:analyzer/dart/element/element.dart';

class NextBuilderLibrary {
  NextBuilderLibrary(this.element);
  final ClassElement element;

  String build() {
    final ClassElement elementSuperType =
        element.allSupertypes.first.typeArguments[1].element;

    final stringBuffer = StringBuffer();
    stringBuffer.writeln(
        'extension ${elementSuperType.displayName}Parser on ${elementSuperType.displayName} {');
    stringBuffer.writeln(
        '${elementSuperType.displayName} _\$parseParameters(Map<String, dynamic> map) {');
    stringBuffer.writeln(' return ${elementSuperType.displayName}()');

    for (var field in elementSuperType.fields) {
      stringBuffer.writeln('..${field.displayName} = ${_safelyCastArg(field)}');
    }
    stringBuffer.writeln(';}}');
    return stringBuffer.toString();
  }

  static final _tryParseableTypeNames = [
    'int',
    'double',
    'DateTime',
  ];

  String _safelyCastArg(FieldElement field) {
    final varName = field.name.toString();
    final typeName = field.type.getDisplayString(withNullability: false);

    if (_tryParseableTypeNames.contains(typeName)) {
      return "map['$varName'] is String ? $typeName.tryParse(map['$varName']) : map['$varName']";
    }

    if (typeName == 'bool') {
      return "map['$varName'] is String ? boolFromString(map['$varName']) : map['$varName']";
    }

    return "map['$varName']";
  }
}
