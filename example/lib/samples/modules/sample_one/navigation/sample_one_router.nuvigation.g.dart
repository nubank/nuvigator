// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample_one_router.dart';

// **************************************************************************
// NuvigationGenerator
// **************************************************************************

class SimulationRouterRoutes {
  static const test = 'SimulationRouter/test';
}

class TestArgs {
  TestArgs({
    @required this.aaa,
  });

  final String aaa;

  static TestArgs parse(Map<String, String> args) {
    return TestArgs(
      aaa: args['aaa'],
    );
  }
}

Map<String, Screen> simulationRouter$getScreensMap(SimulationRouter router) {
  return {
    SimulationRouterRoutes.test: router.test,
  };
}

List<Router> simulationRouter$getSubRoutersList(SimulationRouter router) {
  return [];
}

class SimulationRouterNavigation {
  SimulationRouterNavigation(this.nuvigator);

  static SimulationRouterNavigation of(BuildContext context) =>
      SimulationRouterNavigation(Nuvigator.of(context));

  final NuvigatorState nuvigator;

  Future<Object> test(TestArgs arguments) {
    return nuvigator.pushNamed<Object>(SimulationRouterRoutes.test);
  }
}

class LendingRouterRoutes {
  static const paymentResume = 'LendingRouter/paymentResume';
  static const paymentSucceeded = 'LendingRouter/paymentSucceeded';
  static const paymentSimulations = 'LendingRouter/paymentSimulations';
}

class PaymentResumeArgs {
  PaymentResumeArgs({
    @required this.testId,
  });

  final String testId;

  static PaymentResumeArgs parse(Map<String, String> args) {
    return PaymentResumeArgs(
      testId: args['testId'],
    );
  }
}

class PaymentSucceededArgs {
  PaymentSucceededArgs({
    @required this.myParams,
  });

  final String myParams;

  static PaymentSucceededArgs parse(Map<String, String> args) {
    return PaymentSucceededArgs(
      myParams: args['myParams'],
    );
  }
}

Map<String, Screen> lendingRouter$getScreensMap(LendingRouter router) {
  return {
    LendingRouterRoutes.paymentResume: router.paymentResume,
    LendingRouterRoutes.paymentSucceeded: router.paymentSucceeded,
    LendingRouterRoutes.paymentSimulations: router.paymentSimulations,
  };
}

List<Router> lendingRouter$getSubRoutersList(LendingRouter router) {
  return [];
}

class LendingRouterNavigation {
  LendingRouterNavigation(this.nuvigator);

  static LendingRouterNavigation of(BuildContext context) =>
      LendingRouterNavigation(Nuvigator.of(context));

  final NuvigatorState nuvigator;

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

class NuAppRouterRoutes {
  static const mgmNudge = 'NuAppRouter/mgmNudge';
}

Map<String, Screen> nuAppRouter$getScreensMap(NuAppRouter router) {
  return {
    NuAppRouterRoutes.mgmNudge: router.mgmNudge,
  };
}

List<Router> nuAppRouter$getSubRoutersList(NuAppRouter router) {
  return [
    router.lendingRouter,
  ];
}

class NuAppRouterNavigation {
  NuAppRouterNavigation(this.nuvigator);

  static NuAppRouterNavigation of(BuildContext context) =>
      NuAppRouterNavigation(Nuvigator.of(context));

  final NuvigatorState nuvigator;

  LendingRouterNavigation get lendingRouterNavigation =>
      LendingRouterNavigation(nuvigator);
  Future<Object> mgmNudge() {
    return nuvigator.pushNamed<Object>(NuAppRouterRoutes.mgmNudge);
  }
}
