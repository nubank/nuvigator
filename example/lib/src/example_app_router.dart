import 'package:flutter/material.dart';
import 'package:nuds/nuds.dart';
import 'package:provider/provider.dart';
import 'package:routing/routing.dart';

import '../samples/navigation/samples_navigation.dart';
import '../samples/navigation/samples_router.dart';

class NuCardScreenType extends ScreenType {
  @override
  Route<T> toRoute<T extends Object>(
      WidgetBuilder builder, RouteSettings settings) {
    return NuDSCardStackPageRoute(
      builder: builder,
      settings: settings,
    );
  }
}

final nuCardScreenType = NuCardScreenType();

class NuPageScreenType extends ScreenType {
  @override
  Route<T> toRoute<T extends Object>(
      WidgetBuilder builder, RouteSettings settings) {
    return NuDSPageRoute(
      builder: builder,
      settings: settings,
    );
  }
}

final nuPageScreenType = NuPageScreenType();

class NuScreen {
  static Screen page<T extends Object>(ScreenBuilder screenBuilder) {
    return Screen<T>(
        screenBuilder: screenBuilder, screenType: nuPageScreenType);
  }

  static Screen card<T extends Object>(ScreenBuilder screenBuilder) {
    return Screen<T>(
        screenBuilder: screenBuilder, screenType: nuCardScreenType);
  }
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
