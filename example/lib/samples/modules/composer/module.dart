import 'package:nuvigator/nuvigator.dart';

import 'screens/help_screen.dart';
import 'screens/text_composer_screen.dart';

// ComposerTextModule
abstract class ComposerTextDelegate extends NuModuleRouter {
  void handleCompose();
}

class ComposerTextModule
    extends NuRouteModule<ComposerTextDelegate, void, String> {
  ComposerTextModule(ComposerTextDelegate delegate) : super(delegate);

  @override
  ScreenRoute<String> getRoute(NuRouteMatch<void> match) {
    return ScreenRoute(
      builder: (context) => TextComposerScreen(
        initialText: match.parameters['initialText'],
        submitText: (String text) => delegate.nuvigator.pop(text),
        toHelp: () =>
            delegate.nuvigator.openDeepLink<void>(Uri.parse('composer/help')),
      ),
      screenType: materialScreenType,
    );
  }

  @override
  String get path => 'composer/text';
}

// ComposerHelpModule
abstract class ComposerHelpDelegate extends NuModuleRouter {
  void handleHelp();
}

class ComposerHelpModule
    extends NuRouteModule<ComposerHelpDelegate, void, void> {
  ComposerHelpModule(ComposerHelpDelegate delegate) : super(delegate);

  @override
  ScreenRoute<void> getRoute(NuRouteMatch<void> match) {
    return ScreenRoute(
      builder: (context) => HelpScreen(),
      screenType: cupertinoScreenType,
    );
  }

  @override
  String get path => 'composer/help';
}

// Export Helper

abstract class ComposerModulesDelegate
    implements ComposerHelpDelegate, ComposerTextDelegate {}

class ComposerModulesRouter extends NuModuleRouter
    implements ComposerModulesDelegate {
  @override
  String get initialRoute => null;

  @override
  List<NuRouteModule> get modules => [
        ComposerTextModule(this),
        ComposerHelpModule(this),
      ];

  @override
  void handleCompose() {
    // TODO: implement handleCompose
  }

  @override
  void handleHelp() {
    // TODO: implement handleHelp
  }
}
