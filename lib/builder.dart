import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:source_gen/source_gen.dart';

final _dartfmt = DartFormatter();

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

DartType getGenericTypes(DartType type) {
  return type is ParameterizedType ? type.typeArguments.first : null;
}

const _nuRouteChecker = TypeChecker.fromRuntime(NuRoute);
const _nuSobRouterChecker = TypeChecker.fromRuntime(NuSubRouter);

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

String lowerCamelCase(String s) => s[0].toLowerCase() + s.substring(1);

class NuvigationGenerator extends GeneratorForAnnotation<NuRouter> {
  Method screensMapMethod(ClassElement classElement, String code) {
    final className = classElement.name;
    final lowerClassName = lowerCamelCase(classElement.name);

    return Method(
      (b) => b
        ..body = const Code('')
        ..name = '$lowerClassName\$getScreensMap'
        ..requiredParameters.add(
          Parameter(
            (p) => p
              ..type = refer(className)
              ..name = 'router',
          ),
        )
        ..returns = refer('Map<String, Screen>')
        ..body = Code('return {$code};'),
    );
  }

  Method subRoutersListMethod(ClassElement classElement) {
    final className = classElement.name;
    final lowerClassName = lowerCamelCase(classElement.name);

    return Method(
      (b) => b
        ..body = const Code('')
        ..name = '$lowerClassName\$getSubRoutersList'
        ..requiredParameters.add(
          Parameter(
            (p) => p
              ..type = refer(className)
              ..name = 'router',
          ),
        )
        ..returns = refer('List<Router>'),
    );
  }

  Class generateNavigationClass(
      ClassElement classElement, List<Method> methods) {
    final className = classElement.name;
    final lowerClassName = lowerCamelCase(classElement.name);

    return Class(
      (b) => b
        ..name = '${className}Navigation'
        ..constructors.add(
          Constructor(
            (c) => c
              ..requiredParameters.add(
                Parameter(
                  (p) => p
                    ..name = 'nuvigator'
                    ..toThis = true,
                ),
              ),
          ),
        )
        ..fields.add(
          Field(
            (f) => f
              ..name = 'nuvigator'
              ..type = refer('NuvigatorState')
              ..modifier = FieldModifier.final$,
          ),
        )
        ..methods.addAll(
          [
            Method(
              (m) => m
                ..name = 'of'
                ..requiredParameters.add(
                  Parameter(
                    (p) => p
                      ..name = 'context'
                      ..type = refer('BuildContext'),
                  ),
                )
                ..returns = refer(b.name)
                ..body = Code('${b.name}(Nuvigator.of(context))')
                ..lambda = true
                ..static = true,
            ),
            ...methods,
          ],
        ),
    );
  }

  Class generateRoutesClass(ClassElement classElement, List<Field> fields) {
    final className = classElement.name;
    final lowerClassName = lowerCamelCase(classElement.name);

    return Class(
      (b) => b
        ..name = '${className}Routes'
        ..fields.addAll(fields),
    );
  }

  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    final ClassElement classElement = element;
    final className = classElement.name;
    final lowerClassName = lowerCamelCase(classElement.name);

    final screensMapBuffer = StringBuffer();

    final listSpecs = <Spec>[];
    final fieldsRoutesClass = <Field>[];
    final methodsNavigationClass = <Method>[];

    for (final field in classElement.fields) {
      String navigationFnParams = '';
      final nuRouteFieldAnnotation =
          _nuRouteChecker.firstAnnotationOfExact(field);
      final nuSubRouterAnnotation =
          _nuSobRouterChecker.firstAnnotationOfExact(field);

      if (nuRouteFieldAnnotation != null) {
        final argsBuffer = StringBuffer();
        final args = nuRouteFieldAnnotation?.getField('args')?.toMapValue();

        final subRouter =
            nuRouteFieldAnnotation?.getField('subRouter')?.toTypeValue();

        if (args != null) {
          final argsParserBuffer = StringBuffer('');
          final argsClassName = '${capitalize(field.name)}Args';

          final parametersConstructor = <Parameter>[];
          final fieldsArgs = <Field>[];

          for (final argEntry in args.entries) {
            final typeName = argEntry.value.toTypeValue().name;
            final varName = argEntry.key.toStringValue();

            argsParserBuffer.write("$varName: args['$varName'],\n");

            parametersConstructor.add(
              Parameter(
                (p) => p
                  ..name = varName
                  ..named = true
                  ..annotations.add(
                    const CodeExpression(
                      Code('required'),
                    ),
                  )
                  ..toThis = true,
              ),
            );

            fieldsArgs.add(
              Field(
                (m) => m
                  ..name = varName
                  ..type = refer(typeName)
                  ..modifier = FieldModifier.final$,
              ),
            );
          }

          final argsClass = Class(
            (c) => c
              ..name = argsClassName
              ..constructors.add(
                Constructor(
                  (c) => c..optionalParameters.addAll(parametersConstructor),
                ),
              )
              ..fields.addAll(fieldsArgs)
              ..methods.add(
                Method(
                  (m) => m
                    ..name = 'parse'
                    ..requiredParameters.add(
                      Parameter((p) => p
                        ..name = 'args'
                        ..type = refer('Map<String, String>')),
                    )
                    ..returns = refer(argsClassName)
                    ..static = true
                    ..body = Code(
                        'return $argsClassName(${argsParserBuffer.toString()});'),
                ),
              ),
          );

          listSpecs.add(argsClass);

          navigationFnParams = argsClassName;
        }

        final screenReturn = getGenericTypes(field.type);

        screensMapBuffer
            .write('${className}Routes.${field.name}: router.${field.name},\n');

        fieldsRoutesClass.add(
          Field(
            (f) => f
              ..name = field.name
              ..assignment = Code("'$className/${field.name}'")
              ..modifier = FieldModifier.constant
              ..static = true,
          ),
        );

        final methodParams = navigationFnParams.isEmpty
            ? <Parameter>[]
            : [
                Parameter(
                  (p) => p
                    ..name = 'arguments'
                    ..type = refer(navigationFnParams),
                )
              ];

        methodsNavigationClass.add(
          Method(
            (m) => m
              ..name = field.name
              ..returns = refer('Future<$screenReturn>')
              ..requiredParameters.addAll(methodParams)
              ..body = Code(
                'return nuvigator.pushNamed<$screenReturn>(${className}Routes.${field.name});',
              ),
          ),
        );

        if (subRouter != null) {
          methodsNavigationClass.add(
            Method(
              (m) => m
                ..name = '${lowerCamelCase(subRouter.name)}Navigation'
                ..returns = refer('${subRouter.name}Navigation')
                ..type = MethodType.getter
                ..lambda = true
                ..body = Code(
                  '${subRouter.name}Navigation(nuvigator)',
                ),
            ),
          );
        }
      } else if (nuSubRouterAnnotation != null) {
//        subRoutersListBuffer.write('router.${field.name},\n');
//        navigationBuffer.write(
//            '${field.type.name}Navigation get ${lowerCamelCase(field.name)}Navigation => ${field.type.name}Navigation(nuvigator);\n');
      }
    }

    final lib = Library((l) => l.body.addAll([
          generateRoutesClass(classElement, fieldsRoutesClass),
          generateNavigationClass(classElement, methodsNavigationClass),
          screensMapMethod(classElement, screensMapBuffer.toString()),
          ...listSpecs
        ]));
    final libCode = _dartfmt.format('${lib.accept(DartEmitter())}');
    print(libCode);
    return libCode;
  }
}

Builder nuvigationBuilder(BuilderOptions options) =>
    PartBuilder([NuvigationGenerator()], '.nuvigation.g.dart');
