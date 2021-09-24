import 'package:nuvigator/next.dart';
import 'package:flutter/material.dart';
import 'package:simple_route_parameters_implementation/screens/age_screen.dart';

class AgeRequestArgs {
  AgeRequestArgs({this.param});
  final String param;

  static AgeRequestArgs fromJson(Map<String, dynamic> json) {
    return AgeRequestArgs(
      param: json['param'],
    );
  }

  @override
  String toString() {
    return 'AgeRequestArgs(name: $param)';
  }
}

// Arguments of this Route specifies the following:
// 1. be installed on any NuRouter
// 2. to receive arguments that can be parsed into a OneRequestArgs class
// 3. when popped will return a String
class AgeRoute extends NuRoute<NuRouter, AgeRequestArgs, String> {
  @override
  String get path => 'age';

  @override
  ScreenType get screenType => materialScreenType;

  /// Flutter does not have support for reflection, we need to explicitly provide a function to parse
  /// the [NuRouteSettings.rawParameters] into the specified class that will be made available in [NuRouteSettings.args]
  @override
  ParamsParser<AgeRequestArgs> get paramsParser => AgeRequestArgs.fromJson;

  @override
  Widget build(BuildContext context, NuRouteSettings<AgeRequestArgs> settings) {

    /// Map<String, dynamic> with the raw arguments passed to the route
    print(settings.rawParameters);

    /// OneRequestArgs instance with the parsed arguments
    print(settings.arguments);

    return AgeScreen(
      param: settings.args?.param,
      // The same work for nested flows when calling `closeFlow` to return a flow result
      onClose: () => nuvigator.pop('Hello, I\'m a returned parameter'),
    );
  }
}