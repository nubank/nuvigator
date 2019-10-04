import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';

import 'routers.dart';
import 'screen.dart';
import 'screen_widget.dart';

typedef GetScreenFn = Screen Function({String routeName});

class NuvigatorScreen extends ScreenWidget {
  NuvigatorScreen({this.router, this.initialRoute, ScreenContext screenContext})
      : super(screenContext);

  final Router router;
  final String initialRoute;

  static NuvigatorScreen Function(ScreenContext screenContext)
      fromScreenContext({Router router, String initialRoute}) {
    return (ScreenContext screenContext) => NuvigatorScreen(
          router: router,
          initialRoute: initialRoute,
          screenContext: screenContext,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Nuvigator(
      initialArguments: args,
      initialRoute: initialRoute,
      router: router,
    );
  }
}
