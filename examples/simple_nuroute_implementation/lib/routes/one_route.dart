import 'package:nuvigator/next.dart';
import 'package:flutter/material.dart';
import 'package:simple_nuroute_implementation/screens/one_screen.dart';

class OneRoute extends NuRoute {
  @override
  String get path => 'one';

  @override
  ScreenType get screenType => materialScreenType;

  @override
  Widget build(BuildContext context, NuRouteSettings settings) {
    return OneScreen(
      onScreenTwoClick: () => nuvigator.open('two'),
      onScreenThreeClick: () => nuvigator.open('three'),
      onClose: () => nuvigator.pop(),
    );
  }
}