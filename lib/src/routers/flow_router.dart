import 'package:flutter/widgets.dart';
import 'package:nuvigator/nuvigator.dart';

import '../nuvigator_screen.dart';
import '../screen.dart';
import '../screen_type.dart';

/// Special type of Router that will try to find the screen in it's provided
/// baseRouter, but instead will return a nested Navigator.
/// The first screen being the found screen, and at each new push it will
/// look into for the new Screen again in it's baseRouter. This should be used when
/// you have a more complex flow, composed of multiple screens creating a "journey".
/// this router already handles the pop mechanism for you. Also if it does not find
/// the route in itself it will dispatch to it's parent Navigator the opportunity
/// to match it.
class FlowRouter<T extends Object> extends SimpleRouter {
  FlowRouter(
      {@required this.baseRouter, this.initialScreenType, this.flowWrapper});

  final ScreenType initialScreenType;
  final Router baseRouter;
  final WrapperFn flowWrapper;

  @override
  Screen getScreen({String routeName}) {
    final firstScreen = baseRouter.getScreen(routeName: routeName);
    if (firstScreen == null) return null;

    return Screen<T>((screenContext) {
      final newScreenContext = ScreenContext(
          settings: screenContext.settings.copyWith(name: routeName),
          context: screenContext.context);
      return NuvigatorScreen(
          router: baseRouter,
          initialRoute: routeName,
          screenContext: newScreenContext);
    },
        screenType: initialScreenType ?? firstScreen.screenType,
        wrapperFn: flowWrapper);
  }
}
