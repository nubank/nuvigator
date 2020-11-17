import 'package:flutter/material.dart';
import 'package:nuvigator/next.dart';

import 'screens/help_screen.dart';
import 'screens/text_composer_screen.dart';

// ComposerTextModule
abstract class ComposerTextDelegate extends NuModule {
  void handleCompose();
}

class ComposerTextRoute extends NuRoute<ComposerTextDelegate, void, String> {
  @override
  String get path => 'composer/text';

  @override
  ScreenType get screenType => materialScreenType;

  @override
  Widget build(BuildContext context, NuRouteMatch<void> match) {
    return TextComposerScreen(
      initialText: match.parameters['initialText'],
      submitText: (String text) => module.nuvigator.pop(text),
      toHelp: () {
        module.handleCompose();
        module.nuvigator.openDeepLink<void>(Uri.parse('composer/help'));
      },
    );
  }
}

// ComposerHelpModule
abstract class ComposerHelpDelegate extends NuModule {
  void handleHelp();
}

class ComposerHelpRoute extends NuRoute<ComposerHelpDelegate, void, void> {
  @override
  String get path => 'composer/help';

  @override
  ScreenType get screenType => cupertinoScreenType;

  @override
  Widget build(BuildContext context, NuRouteMatch<void> match) {
    return HelpScreen();
  }
}

// Export Helper

abstract class ComposerModulesDelegate
    implements ComposerHelpDelegate, ComposerTextDelegate {}

class ComposerModule extends NuModule implements ComposerModulesDelegate {
  @override
  String get initialRoute => null;

  @override
  List<NuRoute> get createRoutes => [
        ComposerHelpRoute(),
        ComposerTextRoute(),
      ];

  @override
  void handleCompose() {
    print('HandleCompose');
  }

  @override
  void handleHelp() {
    print('HandleHelp');
  }
}
