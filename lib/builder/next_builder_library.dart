
import 'package:analyzer/dart/element/element.dart';

class NextBuilderLibrary {
  NextBuilderLibrary(this.element);
  final ClassElement element;

  ClassElement? get getNuRouteArgsType => element.allSupertypes
      .firstWhere((element) {
        return element
            .getDisplayString(withNullability: false)
            .contains('NuRoute');
      })
      .typeArguments[1]
      .element as ClassElement?;

  String build() {
    final argsClassElement = getNuRouteArgsType;

    final stringBuffer = StringBuffer();
    stringBuffer.writeln(
        'extension ${argsClassElement!.displayName}Parser on ${element.displayName} {');
    stringBuffer.writeln(
        '${argsClassElement.displayName} _\$parseParameters(Map<String, dynamic> map) {');
    stringBuffer.writeln(' return ${argsClassElement.displayName}()');

    for (final field in argsClassElement.fields) {
      if (field.setter != null && field.isPublic) {
        stringBuffer
            .writeln('..${field.displayName} = ${_safelyCastArg(field)}');
      }
    }
    stringBuffer.writeln(';}}');
    return stringBuffer.toString();
  }

  static final _tryParseableTypeNames = [
    'int',
    'double',
    'DateTime',
    'Uri',
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
