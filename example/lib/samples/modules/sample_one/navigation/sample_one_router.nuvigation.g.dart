// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample_one_router.dart';

// **************************************************************************
// NuvigationGenerator
// **************************************************************************

class SimulationRouterRoutes {
  static const test = 'SimulationRouter/test';
}

class SimulationRouterNavigation {
  SimulationRouterNavigation(this.nuvigator);

  final NuvigatorState nuvigator;

  static SimulationRouterNavigation of(BuildContext context) =>
      SimulationRouterNavigation(Nuvigator.of(context));
  Future<Object> test(TestArgs arguments) {
    return nuvigator.pushNamed<Object>(SimulationRouterRoutes.test);
  }
}

Map<String, Screen> simulationRouter$getScreensMap(SimulationRouter router) {
  return {
    SimulationRouterRoutes.test: router.test,
  };
}

class TestArgs {
  TestArgs({@required this.aaa});

  final String aaa;

  static TestArgs parse(Map<String, String> args) {
    return TestArgs(
      aaa: args['aaa'],
    );
  }

  static TestArgs of(BuildContext context) {
    final args = ModalRoute.of(context)?.settings?.arguments;
    if (args is TestArgs) return args;
    if (args is Map<String, String>) return parse(args);
    return null;
  }
}

class LendingRouterRoutes {
  static const paymentResume = 'LendingRouter/paymentResume';

  static const paymentSucceeded = 'LendingRouter/paymentSucceeded';

  static const paymentSimulations = 'LendingRouter/paymentSimulations';
}

class LendingRouterNavigation {
  LendingRouterNavigation(this.nuvigator);

  final NuvigatorState nuvigator;

  static LendingRouterNavigation of(BuildContext context) =>
      LendingRouterNavigation(Nuvigator.of(context));
  Future<Object> paymentResume(PaymentResumeArgs arguments) {
    return nuvigator.pushNamed<Object>(LendingRouterRoutes.paymentResume);
  }

  Future<Object> paymentSucceeded(PaymentSucceededArgs arguments) {
    return nuvigator.pushNamed<Object>(LendingRouterRoutes.paymentSucceeded);
  }

  Future<Object> paymentSimulations() {
    return nuvigator.pushNamed<Object>(LendingRouterRoutes.paymentSimulations);
  }

  SimulationRouterNavigation get simulationRouterNavigation =>
      SimulationRouterNavigation(nuvigator);
}

Map<String, Screen> lendingRouter$getScreensMap(LendingRouter router) {
  return {
    LendingRouterRoutes.paymentResume: router.paymentResume,
    LendingRouterRoutes.paymentSucceeded: router.paymentSucceeded,
    LendingRouterRoutes.paymentSimulations: router.paymentSimulations,
  };
}

class PaymentResumeArgs {
  PaymentResumeArgs({@required this.testId});

  final String testId;

  static PaymentResumeArgs parse(Map<String, String> args) {
    return PaymentResumeArgs(
      testId: args['testId'],
    );
  }

  static PaymentResumeArgs of(BuildContext context) {
    final args = ModalRoute.of(context)?.settings?.arguments;
    if (args is PaymentResumeArgs) return args;
    if (args is Map<String, String>) return parse(args);
    return null;
  }
}

class PaymentSucceededArgs {
  PaymentSucceededArgs({@required this.myParams});

  final String myParams;

  static PaymentSucceededArgs parse(Map<String, String> args) {
    return PaymentSucceededArgs(
      myParams: args['myParams'],
    );
  }

  static PaymentSucceededArgs of(BuildContext context) {
    final args = ModalRoute.of(context)?.settings?.arguments;
    if (args is PaymentSucceededArgs) return args;
    if (args is Map<String, String>) return parse(args);
    return null;
  }
}

class NuAppRouterRoutes {
  static const mgmNudge = 'NuAppRouter/mgmNudge';
}

class NuAppRouterNavigation {
  NuAppRouterNavigation(this.nuvigator);

  final NuvigatorState nuvigator;

  static NuAppRouterNavigation of(BuildContext context) =>
      NuAppRouterNavigation(Nuvigator.of(context));
  Future<Object> mgmNudge() {
    return nuvigator.pushNamed<Object>(NuAppRouterRoutes.mgmNudge);
  }
}

Map<String, Screen> nuAppRouter$getScreensMap(NuAppRouter router) {
  return {
    NuAppRouterRoutes.mgmNudge: router.mgmNudge,
  };
}
