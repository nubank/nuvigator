import 'package:flutter/material.dart';
import 'package:nuvigator/next.dart';

import 'screens/help_screen.dart';
import 'screens/text_composer_screen.dart';

class _ComposerTextRoute extends NuRoute<NuModuleRouter, void, String> {
  @override
  String get path => 'composer/text';

  @override
  ScreenType get screenType => materialScreenType;

  @override
  Widget build(BuildContext context, NuRouteSettings<void> settings) {
    return TextComposerScreen(
      initialText: settings.rawParameters['initialText'],
      submitText: (String text) => module.nuvigator.pop(text),
      toHelp: () {
        module.nuvigator.open<void>('composer/help');
      },
    );
  }
}

class _ComposerHelpRoute extends NuRoute {
  @override
  String get path => 'composer/help';

  @override
  ScreenType get screenType => cupertinoScreenType;

  @override
  Widget build(BuildContext context, NuRouteSettings<void> settings) {
    return HelpScreen();
  }
}

// Export Helper

class ComposerRoute extends NuRoute<NuModuleRouter, void, String> {
  @override
  Widget build(BuildContext context, NuRouteSettings<Object> settings) {
    return Nuvigator.routes(
      initialRoute: settings.name,
      routes: [
        _ComposerHelpRoute(),
        _ComposerTextRoute(),
      ],
    );
  }

  @override
  bool get prefix => true;

  @override
  String get path => 'composer/';

  @override
  ScreenType get screenType => materialScreenType;
}
