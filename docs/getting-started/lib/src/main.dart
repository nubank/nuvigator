import 'package:flutter/material.dart';
import 'package:nuvigator/nuvigator.dart';
import 'router.dart';

void main() {
  runApp(TutorialApp());
}

class TutorialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalRouter = GlobalRouter(baseRouter: TutorialRouter());
    return MaterialApp(
      builder: Nuvigator(
        initialRoute: TutorialRoutes.tutorialRoute,
        router: globalRouter,
      ),
    );
  }
}
