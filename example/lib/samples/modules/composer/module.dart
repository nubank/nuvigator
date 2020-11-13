import 'package:nuvigator/next.dart';

import 'screens/help_screen.dart';
import 'screens/text_composer_screen.dart';

// ComposerTextModule
abstract class ComposerTextDelegate extends NuModule {
  void handleCompose();
}

class ComposerTextRoute extends NuRoute<ComposerTextDelegate, void, String> {
  ComposerTextRoute(ComposerTextDelegate delegate) : super(delegate);

  @override
  String get path => 'composer/text';

  @override
  ScreenRoute<String> getRoute(NuRouteMatch<void> match) {
    return ScreenRoute(
      builder: (context) => TextComposerScreen(
        initialText: match.parameters['initialText'],
        submitText: (String text) => delegate.nuvigator.pop(text),
        toHelp: () {
          delegate.handleCompose();
          delegate.nuvigator.openDeepLink<void>(Uri.parse('composer/help'));
        },
      ),
      screenType: materialScreenType,
    );
  }
}

// ComposerHelpModule
abstract class ComposerHelpDelegate extends NuModule {
  void handleHelp();
}

class ComposerHelpRoute extends NuRoute<ComposerHelpDelegate, void, void> {
  ComposerHelpRoute(ComposerHelpDelegate delegate) : super(delegate);

  @override
  String get path => 'composer/help';

  @override
  ScreenRoute<void> getRoute(NuRouteMatch<void> match) {
    return ScreenRoute(
      builder: (context) => HelpScreen(),
      screenType: cupertinoScreenType,
    );
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
        ComposerHelpRoute(this),
        ComposerTextRoute(this),
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
