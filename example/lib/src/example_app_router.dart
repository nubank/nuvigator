import 'package:flutter/material.dart';
import 'package:nuds/nuds.dart';
import 'package:provider/provider.dart';
import 'package:routing/routing.dart';

import '../samples/navigation/samples_navigation.dart';
import '../samples/navigation/samples_router.dart';

enum NuTransitionType {
  nuPage,
  nuCard,
}

class ExampleNavigation extends NavigationService {
  ExampleNavigation.of(BuildContext context) : super.of(context);

  Future<T> openDeepLink<T>(Uri url) {
    return ExampleAppRouter.of(context).openDeepLink<T>(url);
  }

  // Define modules navigations
  SamplesNavigation get samples => SamplesNavigation.of(context);
}

abstract class ExampleScreenWidget extends ScreenWidget {
  ExampleScreenWidget(ScreenContext screenContext) : super(screenContext);

  @override
  ExampleNavigation get navigation =>
      ExampleNavigation.of(screenContext.context);
}

class ExScreen<T extends Object> extends Screen<T> {
  const ExScreen(
      {ScreenBuilder screenBuilder,
      WrapperFn wrapperFn = defaultWrapperFn,
      this.nuTransitionType})
      : super(screenBuilder: screenBuilder, wrapperFn: wrapperFn);

  const ExScreen.page(
    ScreenBuilder screenBuilder,
  ) : this(
            screenBuilder: screenBuilder,
            nuTransitionType: NuTransitionType.nuPage);

  const ExScreen.card(
    ScreenBuilder screenBuilder,
  ) : this(
            screenBuilder: screenBuilder,
            nuTransitionType: NuTransitionType.nuCard);

  static ScreenFn<T> fromScreen<T extends Object>(
      NuTransitionType nuTransitionType) {
    return <T>({WrapperFn wrapperFn, ScreenBuilder screenBuilder}) =>
        ExScreen<T>(
          nuTransitionType: NuTransitionType.nuCard,
          wrapperFn: wrapperFn,
          screenBuilder: screenBuilder,
        );
  }

  final NuTransitionType nuTransitionType;

  @override
  Screen<T> withWrappedScreen(WrapperFn wrapperFn) {
    return ExScreen<T>(
      nuTransitionType: nuTransitionType,
      screenBuilder: screenBuilder,
      wrapperFn: getComposedWrapper(wrapperFn),
    );
  }

  @override
  Route<T> toRoute(RouteSettings settings) {
    switch (nuTransitionType) {
      case NuTransitionType.nuPage:
        return NuDSPageRoute<T>(
          builder: (context) => buildScreen(context, settings),
          settings: settings,
        );
      case NuTransitionType.nuCard:
        return NuDSCardStackPageRoute<T>(
          builder: (context) => buildScreen(context, settings),
          settings: settings,
        );
    }
    return null;
  }
}

class ExampleAppRouter extends GlobalRouter {
  ExampleAppRouter(GlobalKey<NavigatorState> navigatorKey)
      : super(navigatorKey);

  static ExampleAppRouter of(BuildContext context) =>
      Provider.of<ExampleAppRouter>(context);

  @override
  List<Router> get routers => [
        samplesRouter,
      ];

  @override
  Future<bool> canOpenDeepLink(Uri url) async {
    return await super.canOpenDeepLink(url);
  }

  @override
  Future<T> openDeepLink<T>(Uri url, [dynamic arguments]) async {
    return super.openDeepLink<T>(url, arguments);
  }

  Future<dynamic> openInternalFromNative(Uri url, [dynamic arguments]) async {
    return handleDeepLink(url, true);
  }
}
