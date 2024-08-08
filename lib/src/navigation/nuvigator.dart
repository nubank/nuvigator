import 'package:flutter/material.dart';
import 'package:nuvigator/src/navigation/inu_router.dart';
import 'package:nuvigator/src/navigation/nuvigator_inner.dart';
import 'package:nuvigator/src/navigation/nuvigator_state.dart';

import '../../next.dart';

/// Creates a new Nuvigator. When using the Next API, several of those options
/// are provided by the [INuRouter]. Providing them here will thrown an assertion
/// error.
@immutable
class Nuvigator<T extends INuRouter?> extends StatelessWidget {
  const Nuvigator({
    required this.router,
    this.initialArguments,
    Key? key,
    this.observers = const [],
    this.wrapper,
    this.debug = false,
    this.inheritableObservers = const [],
    this.shouldPopRoot = false,
    this.shouldRebuild,
  })  : _innerKey = key,
        assert(router != null);

  /// Creates a [Nuvigator] from a list of [NuRoute]
  static Nuvigator<NuRouterBuilder> routes({
    required String initialRoute,
    required List<NuRoute> routes,
    ScreenType? screenType,
    List<ObserverBuilder> inheritableObservers = const [],
    List<NavigatorObserver> observers = const [],
    bool debug = false,
    bool shouldPopRoot = false,
    ShouldRebuildFn? shouldRebuild,
    Key? key,
  }) {
    return Nuvigator(
      key: key,
      inheritableObservers: inheritableObservers,
      debug: debug,
      observers: observers,
      shouldPopRoot: shouldPopRoot,
      shouldRebuild: shouldRebuild,
      router: NuRouterBuilder(
        routes: routes,
        initialRoute: initialRoute,
        screenType: screenType,
      ),
    );
  }

  final T router;
  final bool debug;
  final bool shouldPopRoot;
  final WrapperFn? wrapper;
  final List<ObserverBuilder> inheritableObservers;
  final List<NavigatorObserver> observers;
  final Key? _innerKey;
  final Map<String, Object>? initialArguments;
  final ShouldRebuildFn? shouldRebuild;

  /// Fetches a [NuvigatorState] from the current BuildContext.
  static NuvigatorState<T>? of<T extends INuRouter>(
      BuildContext context, {
        bool rootNuvigator = false,
        bool nullOk = false,
      }) {
    if (rootNuvigator) {
      return context.findRootAncestorStateOfType<NuvigatorState<T>>();
    } else {
      final closestNuvigator =
      context.findAncestorStateOfType<NuvigatorState<T>>();
      if (closestNuvigator != null) return closestNuvigator;
      assert(() {
        if (!nullOk) {
          throw FlutterError(
              'Nuvigator operation requested with a context that does not include a Nuvigator.\n'
                  'The context used to push or pop routes from the Nuvigator must be that of a '
                  'widget that is a descendant of a Nuvigator widget.'
                  'Also check if the provided Router [T] type exists withing a the Nuvigator context.');
        }
        return true;
      }());
      return null;
    }
  }

  /// Helper method that allows passing a Nuvigator to a builder function
  Nuvigator call(BuildContext context, [Widget? child]) {
    return this;
  }

  @override
  Widget build(BuildContext context) {
    return NuRouterLoader(
      // ignore: avoid_as
      router: router as NuRouter,
      shouldRebuild: shouldRebuild,
      builder: (moduleRouter) => NuvigatorInner(
        router: moduleRouter,
        debug: debug,
        inheritableObservers: inheritableObservers,
        observers: observers,
        initialDeepLink: moduleRouter.initialRoute,
        screenType: moduleRouter.screenType ?? materialScreenType,
        key: _innerKey,
        initialArguments: initialArguments,
        shouldPopRoot: shouldPopRoot,
      ),
    );
  }
}