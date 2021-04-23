

import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';

abstract class BaseBuilder {
  BaseBuilder(this.classElement);

  final ClassElement classElement;

  Spec build();
}
