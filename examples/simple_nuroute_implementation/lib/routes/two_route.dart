import 'package:nuvigator/next.dart';
import 'package:flutter/material.dart';
import 'package:simple_nuroute_implementation/screens/two_screen.dart';

class TwoRoute extends NuRoute {
  @override
  String get path => 'two';

  @override
  ScreenType get screenType => materialScreenType;

  @override
  Widget build(BuildContext context, NuRouteSettings settings) {
    return TwoScreen(
        onScreenOneClick: () => nuvigator.open('one'),
        onScreenThreeClick: () => nuvigator.open('three'),
        onClose: () => nuvigator.pop()
    );
  }
}