import 'package:nuvigator/next.dart';
import 'package:flutter/material.dart';
import 'package:simple_nuroute_implementation/screens/three_screen.dart';

class ThreeRoute extends NuRoute {
  @override
  String get path => 'three';

  @override
  ScreenType get screenType => materialScreenType;

  @override
  Widget build(BuildContext context, NuRouteSettings settings) {
    return ThreeScreen(
        onScreenOneClick: () => nuvigator.open('one'),
        onScreenTwoClick: () => nuvigator.open('two'),
        onClose: () => nuvigator.pop()
    );
  }
}