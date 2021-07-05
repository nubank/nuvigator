// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_router.dart';

// **************************************************************************
// NuvigatorGenerator
// **************************************************************************

class TestRoutes {
  static const home = 'test/home';

  static const testArgs = 'test/testArgs';
}

class TestArgsArgs {
  TestArgsArgs(
      {required this.intArg,
      required this.doubleArg,
      required this.boolArg,
      required this.dateTimeArg,
      required this.dateArg,
      required this.stringArg});

  final int? intArg;

  final double? doubleArg;

  final bool? boolArg;

  final DateTime? dateTimeArg;

  final DateTime? dateArg;

  final String? stringArg;

  static TestArgsArgs parse(Map<String, Object?>? args) {
    if (args == null) {
      return TestArgsArgs(
          intArg: null,
          doubleArg: null,
          boolArg: null,
          dateTimeArg: null,
          dateArg: null,
          stringArg: null);
    }
    return TestArgsArgs(
      intArg: args['intArg'] is String
          ? int?.tryParse(args['intArg'].toString())
          : args['intArg'] as int?,
      doubleArg: args['doubleArg'] is String
          ? double?.tryParse(args['doubleArg'].toString())
          : args['doubleArg'] as double?,
      boolArg: args['boolArg'] is String
          ? boolFromString(args['boolArg'].toString())
          : args['boolArg'] as bool?,
      dateTimeArg: args['dateTimeArg'] is String
          ? DateTime?.tryParse(args['dateTimeArg'].toString())
          : args['dateTimeArg'] as DateTime?,
      dateArg: args['dateArg'] is String
          ? DateTime?.tryParse(args['dateArg'].toString())
          : args['dateArg'] as DateTime?,
      stringArg: args['stringArg'] as String?,
    );
  }

  Map<String, Object?> get toMap => {
        'intArg': intArg,
        'doubleArg': doubleArg,
        'boolArg': boolArg,
        'dateTimeArg': dateTimeArg,
        'dateArg': dateArg,
        'stringArg': stringArg,
      };
  static TestArgsArgs? of(BuildContext context) {
    final routeSettings = ModalRoute.of(context)?.settings;
    final nuvigator = Nuvigator.of(context);
    if (routeSettings?.name == TestRoutes.testArgs) {
      final args = routeSettings?.arguments;
      if (args == null)
        throw FlutterError('TestArgsArgs requires Route arguments');
      if (args is TestArgsArgs) return args;
      if (args is Map<String, Object>) return parse(args);
    } else if (nuvigator != null) {
      return of(nuvigator.context);
    }
    return null;
  }
}

extension TestRouterNavigation on TestRouter {
  Future<void> toHome() async {
    return nuvigator?.pushNamed<void>(
      TestRoutes.home,
    );
  }

  Future<void> pushReplacementToHome<TO extends Object?>({TO? result}) async {
    return nuvigator?.pushReplacementNamed<void, TO?>(
      TestRoutes.home,
      result: result,
    );
  }

  Future<void> pushAndRemoveUntilToHome<TO extends Object?>(
      {required RoutePredicate predicate}) async {
    return nuvigator?.pushNamedAndRemoveUntil<void>(
      TestRoutes.home,
      predicate,
    );
  }

  Future<void> popAndPushToHome<TO extends Object?>({TO? result}) async {
    return nuvigator?.popAndPushNamed<void, TO?>(
      TestRoutes.home,
      result: result,
    );
  }

  Future<void> toTestArgs(
      {int? intArg,
      double? doubleArg,
      bool? boolArg,
      DateTime? dateTimeArg,
      DateTime? dateArg,
      String? stringArg}) async {
    return nuvigator?.pushNamed<void>(
      TestRoutes.testArgs,
      arguments: {
        'intArg': intArg,
        'doubleArg': doubleArg,
        'boolArg': boolArg,
        'dateTimeArg': dateTimeArg,
        'dateArg': dateArg,
        'stringArg': stringArg,
      },
    );
  }

  Future<void> pushReplacementToTestArgs<TO extends Object?>(
      {int? intArg,
      double? doubleArg,
      bool? boolArg,
      DateTime? dateTimeArg,
      DateTime? dateArg,
      String? stringArg,
      TO? result}) async {
    return nuvigator?.pushReplacementNamed<void, TO?>(
      TestRoutes.testArgs,
      arguments: {
        'intArg': intArg,
        'doubleArg': doubleArg,
        'boolArg': boolArg,
        'dateTimeArg': dateTimeArg,
        'dateArg': dateArg,
        'stringArg': stringArg,
      },
      result: result,
    );
  }

  Future<void> pushAndRemoveUntilToTestArgs<TO extends Object?>(
      {int? intArg,
      double? doubleArg,
      bool? boolArg,
      DateTime? dateTimeArg,
      DateTime? dateArg,
      String? stringArg,
      required RoutePredicate predicate}) async {
    return nuvigator?.pushNamedAndRemoveUntil<void>(
      TestRoutes.testArgs,
      predicate,
      arguments: {
        'intArg': intArg,
        'doubleArg': doubleArg,
        'boolArg': boolArg,
        'dateTimeArg': dateTimeArg,
        'dateArg': dateArg,
        'stringArg': stringArg,
      },
    );
  }

  Future<void> popAndPushToTestArgs<TO extends Object?>(
      {int? intArg,
      double? doubleArg,
      bool? boolArg,
      DateTime? dateTimeArg,
      DateTime? dateArg,
      String? stringArg,
      TO? result}) async {
    return nuvigator?.popAndPushNamed<void, TO?>(
      TestRoutes.testArgs,
      arguments: {
        'intArg': intArg,
        'doubleArg': doubleArg,
        'boolArg': boolArg,
        'dateTimeArg': dateTimeArg,
        'dateArg': dateArg,
        'stringArg': stringArg,
      },
      result: result,
    );
  }
}

extension TestRouterScreensAndRouters on TestRouter {
  Map<RouteDef, ScreenRouteBuilder> get _$screensMap {
    return {
      RouteDef(TestRoutes.home, deepLink: 'home'): (RouteSettings settings) {
        return home();
      },
      RouteDef(TestRoutes.testArgs, deepLink: 'testargs'):
          (RouteSettings settings) {
        final args =
            TestArgsArgs.parse(settings.arguments as Map<String, Object?>?);
        return testArgs(
            intArg: args.intArg,
            doubleArg: args.doubleArg,
            boolArg: args.boolArg,
            dateTimeArg: args.dateTimeArg,
            dateArg: args.dateArg,
            stringArg: args.stringArg);
      },
    };
  }
}
