import 'package:nuvigator/next.dart';
import 'package:flutter/material.dart';
import 'package:simple_route_parameters_implementation/screens/name_screen.dart';

class OneRoute extends NuRoute {
  @override
  String get path => 'name';

  @override
  ScreenType get screenType => materialScreenType;

  @override
  Widget build(BuildContext context, NuRouteSettings settings) {
    return NameScreen(
      name: settings.rawParameters['text'],
      nuvigator: nuvigator,
    );
  }
}