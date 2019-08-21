import 'package:flutter/material.dart';
import 'package:routing/routing.dart';

import 'sample_two_routes.dart';

class SampleTwoNavigation extends NavigationService {
  SampleTwoNavigation.of(BuildContext context) : super.of(context);

  Future<String> start(String testId) =>
      pushNamed<String>(SampleTwoRoutes.screen_one,
          arguments: <String, String>{'testId': testId,});

  Future<String> screenTwo() =>
      pushNamed<String>(SampleTwoRoutes.screen_two);
}