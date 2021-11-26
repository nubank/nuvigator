import 'package:example/samples/modules/friend_request/screens/sub_flow/first_screen.dart';
import 'package:example/samples/modules/friend_request/screens/sub_flow/second_screen.dart';
import 'package:example/samples/modules/friend_request/screens/sub_flow/third_screen.dart';
import 'package:flutter/material.dart';
import 'package:nuvigator/next.dart';

class SubFlowRoute extends NuRoute {
  @override
  ScreenType get screenType => cupertinoScreenType;

  @override
  Widget build(BuildContext context, NuRouteSettings<Object> settings) {
    return const SubFlowMain();
  }

  @override
  String get path => 'sub_flow';
}

class SubFlowMain extends StatefulWidget {
  const SubFlowMain({
    Key key,
  }) : super(key: key);

  @override
  _SubFlowMainState createState() => _SubFlowMainState();
}

class _SubFlowMainState extends State<SubFlowMain> {
  @override
  Widget build(BuildContext context) {
    return Nuvigator(
      router: SubFlowRouter(),
    );
  }
}

class SubFlowRouter extends NuRouter {
  @override
  ScreenType get screenType => cupertinoScreenType;

  @override
  String get initialRoute => 'sub_flow/first_screen';

  @override
  List<NuRoute<NuRouter, Object, Object>> get registerRoutes => [
        NuRouteBuilder(
          path: 'sub_flow/first_screen',
          builder: (_, __, ___) => const FirstScreen(),
        ),
        NuRouteBuilder(
          path: 'sub_flow/second_screen',
          builder: (_, __, ___) => const SecondScreen(),
        ),
        NuRouteBuilder(
          path: 'sub_flow/third_screen',
          builder: (_, __, ___) => const ThirdScreen(),
          screenType: cupertinoDialogScreenType,
        ),
      ];
}
