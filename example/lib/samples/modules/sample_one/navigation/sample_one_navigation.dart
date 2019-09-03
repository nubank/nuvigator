import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';

import 'sample_one_routes.dart';

class SampleOneNavigation extends NavigationService {
  SampleOneNavigation.of(BuildContext context) : super.of(context);

  void start(String testId) =>
      pushNamed<void>(SampleOneRoutes.screen_one, arguments: <String, String>{
        'testId': testId,
      });

  void screenTwo() => pushNamed<void>(SampleOneRoutes.screen_two);
}
