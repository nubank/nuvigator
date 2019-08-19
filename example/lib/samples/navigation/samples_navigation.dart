import 'package:flutter/material.dart';
import 'package:routing/routing.dart';

import '../modules/sample_one/navigation/sample_one_navigation.dart';

class SamplesNavigation extends NavigationService {
  SamplesNavigation.of(BuildContext context) : super.of(context);

  SampleOneNavigation get sampleOne =>
      SampleOneNavigation.of(context);
}