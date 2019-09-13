import 'package:flutter/widgets.dart';

import '../navigator_screen.dart';
import '../screen.dart';
import '../screen_type.dart';
import 'simple_router.dart';

/// Special type of Router that will try to find the screen in it's provided
/// baseRouter, but instead will return a nested Navigator.
/// The first screen being the found screen, and at each new push it will
/// look into for the new Screen again in it's baseRouter. This should be used when
/// you have a more complex flow, composed of multiple screens creating a "journey".
/// this router already handles the pop mechanism for you. Also if it does not find
/// the route in itself it will dispatch to it's parent Navigator the opportunity
/// to match it.
mixin FlowRouter<T extends Object> on SimpleRouter {
  final String initialRouteName = null;
  final ScreenType initialScreenType = null;

  Widget flowWrapper(ScreenContext screenContext, Widget screenWidget) =>
      defaultWrapperFn(screenContext, screenWidget);

  @override
  Screen getScreen({String routeName}) {
    final firstScreen = super.getScreen(routeName: routeName);
    if (firstScreen == null) return null;

    return Screen<T>(
      wrapperFn: flowWrapper,
      screenType: initialScreenType ?? firstScreen.screenType,
      screenBuilder: (screenContext) {
        final newScreenContext = ScreenContext(
            settings: screenContext.settings.copyWith(name: routeName),
            context: screenContext.context);
        return NavigatorScreen(newScreenContext, super.getScreen);
      },
    );
  }

  Screen get initialScreen => getScreen(routeName: initialRouteName);
}
