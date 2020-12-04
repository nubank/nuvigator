import 'package:flutter/material.dart';

import 'package:nuvigator/next.dart';
import 'package:nuvigator/src/next/v1/annotations.dart';

part 'nu_module_example.g.dart';

class FriendRequestArgs {
  int numberOfRequests;
  double precision;
  String name;
  int age;

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is FriendRequestArgs &&
        o.numberOfRequests == numberOfRequests &&
        o.precision == precision &&
        o.name == name &&
        o.age == age;
  }

  @override
  int get hashCode {
    return numberOfRequests.hashCode ^
        precision.hashCode ^
        name.hashCode ^
        age.hashCode;
  }
}

@NuRouteParser()
class FriendRequestRouteExample
    extends NuRoute<NuRouter, FriendRequestArgs, void> {
  @override
  String get path => 'friend-requests';

  @override
  Future<bool> init(BuildContext context) {
    return Future.delayed(const Duration(seconds: 3), () => true);
  }

  @override
  ScreenType get screenType => materialScreenType;

  @override
  Widget build(
      BuildContext context, NuRouteSettings<FriendRequestArgs> settings) {
    return Nuvigator(
      router: null,
      screenType: materialScreenType,
    );
  }

  FriendRequestArgs parseParameters(Map<String, dynamic> map) =>
      _$parseParameters(map);
}
