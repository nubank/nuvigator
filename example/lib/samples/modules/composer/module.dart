import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nuvigator/nuvigator.dart';

// ComposerTextModule
abstract class ComposerTextDelegate extends NuModuleRouter {
  void handleCompose();
}

class ComposerTextModule
    extends NuRouteModule<ComposerTextDelegate, void, void> {
  ComposerTextModule(ComposerTextDelegate delegate) : super(delegate);

  @override
  Route<Object> getRoute(RouteMatch<Object> match) {
    return MaterialPageRoute(
      builder: (context) => Container(),
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
  Route<void> getRoute(RouteMatch<void> match) {
    return MaterialPageRoute(
      builder: (context) => Container(),
    );
  }

  @override
  String get path => 'composer/help';
}

// Export Helper

abstract class ComposerModulesDelegate
    implements ComposerHelpDelegate, ComposerTextDelegate {}

List<NuRouteModule> composerModules(ComposerModulesDelegate delegate) {
  return [
    ComposerTextModule(delegate),
    ComposerHelpModule(delegate),
  ];
}

class MainAppModuleRouter extends NuModuleRouter
    implements ComposerModulesDelegate {
  @override
  String get initialRoute => 'composer/text';

  @override
  List<NuRouteModule> get modules => composerModules(this);

  @override
  void handleCompose() {
    print('handling composer text');
  }

  @override
  void handleHelp() {
    print('handling composer help');
  }
}

Widget main() {
  return Nuvigator2(
    moduleRouter: MainAppModuleRouter(),
  );
}
