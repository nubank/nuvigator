import 'package:flutter/material.dart';
import 'package:routing/routing.dart';

import 'sample_one_routes.dart';

class SampleOneNavigation extends NavigationService {
  SampleOneNavigation.of(BuildContext context) : super.of(context);

  void start(String testId) =>
      navigator.pushNamed(SampleOneRoutes.screen_one,
          arguments: {'testId': testId,});
}