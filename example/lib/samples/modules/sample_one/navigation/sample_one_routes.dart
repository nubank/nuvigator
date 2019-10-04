import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';

const _prefix = 'sample_one';

class SampleOneRoutes {
  static const screen_one = '$_prefix/screen_one';
  static const screen_two = '$_prefix/screen_two';
}

class ScreenTwoRoute extends ScreenRoute<int> {
  ScreenTwoRoute({@required String name}) {
    params = {'name': name};
  }

  @override
  String get routeName => SampleOneRoutes.screen_two;
}
