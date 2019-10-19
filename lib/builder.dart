import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:nuvigator/src/annotations.dart';
import 'package:source_gen/source_gen.dart';

import 'builder/builder_library.dart';

class NuvigatorGenerator extends GeneratorForAnnotation<NuRouter> {
  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is ClassElement) {
      final ClassElement classElement = element;
      final lib = BuilderLibrary(classElement).build();
      return DartFormatter().format('${lib.accept(DartEmitter())}');
    }
    return null;
  }
}

Builder nuvigatorBuilder(BuilderOptions options) =>
    SharedPartBuilder([NuvigatorGenerator()], 'nuvigator');
