import 'package:flutter/material.dart';
import 'package:nuvigator/next.dart';
import 'package:nuvigator/src/navigation/inu_router.dart';
import 'package:nuvigator/src/navigation/nuvigator_state.dart';

class NuvigatorInner<T extends INuRouter> extends Navigator {
  NuvigatorInner({
    required this.router,
    required String initialDeepLink,
    Map<String, Object>? initialArguments,
    Key? key,
    List<NavigatorObserver> observers = const [],
    this.screenType = materialScreenType,
    this.wrapper,
    this.debug = false,
    this.inheritableObservers = const [],
    this.shouldPopRoot = false,
  }) : super(
    observers: [
      HeroController(),
      ...observers,
    ],
    onGenerateInitialRoutes: (_, __) {
      final r = router.getRoute<dynamic>(
        deepLink: initialDeepLink,
        parameters: initialArguments,
        fallbackScreenType: screenType,
      );
      if (r == null) {
        throw FlutterError(
            'No Route was found for the initialRoute provided: "$initialDeepLink"'
                ' .Be sure that the provided initialRoute exists in this Router ($router).');
      }
      return [r];
    },
    onGenerateRoute: (settings) {
      assert(
      settings.name != null, 'RouteSettings name should not be null');
      return router.getRoute<dynamic>(
        deepLink: settings.name!,
        parameters: settings.arguments,
        fallbackScreenType: screenType,
      );
    },
    key: key,
  );

  final T router;
  final bool debug;
  final bool shouldPopRoot;
  final ScreenType screenType;
  final WrapperFn? wrapper;
  final List<ObserverBuilder> inheritableObservers;

  @override
  NavigatorState createState() {
    return NuvigatorState<T>();
  }
}