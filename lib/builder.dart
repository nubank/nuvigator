import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:source_gen/source_gen.dart';

import 'builder/builder_library.dart';

class NuRouter {
  const NuRouter();
}

const nuRouter = NuRouter();

class NuSubRouter {
  const NuSubRouter();
}

const nuSubRouter = NuSubRouter();

class NuRoute {
  const NuRoute({this.args, this.subRouter});

  final Map<String, Type> args;
  final Type subRouter;
}

class NuvigationGenerator extends GeneratorForAnnotation<NuRouter> {
  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    final ClassElement classElement = element;

    final lib = BuilderLibrary(classElement).build();
    return DartFormatter().format('${lib.accept(DartEmitter())}');
  }
}

Builder nuvigationBuilder(BuilderOptions options) =>
    PartBuilder([NuvigationGenerator()], '.nuvigation.g.dart');
