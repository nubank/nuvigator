import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:nuvigator/builder/next_builder_library.dart';
import 'package:nuvigator/src/annotations.dart';
import 'package:nuvigator/src/next/v1/annotations.dart';
import 'package:source_gen/source_gen.dart';

import 'builder/builder_library.dart';

class NuvigatorGenerator extends GeneratorForAnnotation<NuRouterAnnotation> {
  @override
  FutureOr<String>? generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is ClassElement) {
      final classElement = element;
      final lib = BuilderLibrary(classElement).build();
      return DartFormatter().format(lib.accept(DartEmitter()).toString());
    }
    return null;
  }
}

class NextGenerator extends GeneratorForAnnotation<NuRouteParser> {
  @override
  FutureOr<String>? generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is ClassElement) {
      return NextBuilderLibrary(element).build();
    }
    return null;
  }
}

Builder nuvigatorBuilder(BuilderOptions options) =>
    SharedPartBuilder([NuvigatorGenerator(), NextGenerator()], 'nuvigator');
