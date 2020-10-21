// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'composer_routes.dart';

// **************************************************************************
// NuvigatorGenerator
// **************************************************************************

class ComposerRoutes {
  static const composeText = '/text';

  static const help = 'help';
}

class ComposeTextArgs {
  ComposeTextArgs({@required this.initialText});

  final String initialText;

  static ComposeTextArgs parse(Map<String, Object> args) {
    if (args == null) {
      return ComposeTextArgs(initialText: null);
    }
    return ComposeTextArgs(
      initialText: args['initialText'],
    );
  }

  Map<String, Object> get toMap => {
        'initialText': initialText,
      };
  static ComposeTextArgs of(BuildContext context) {
    final routeSettings = ModalRoute.of(context)?.settings;
    final nuvigator = Nuvigator.of(context);
    if (routeSettings?.name == ComposerRoutes.composeText) {
      final args = routeSettings?.arguments;
      if (args == null)
        throw FlutterError('ComposeTextArgs requires Route arguments');
      if (args is ComposeTextArgs) return args;
      if (args is Map<String, Object>) return parse(args);
    } else if (nuvigator != null) {
      return of(nuvigator.context);
    }
    return null;
  }
}

extension ComposerRouterNavigation on ComposerRouter {
  String composeTextDeepLink({String initialText}) => encodeDeepLink(
          pathWithPrefix(ComposerRoutes.composeText), <String, dynamic>{
        'initialText': initialText,
      });
  Future<String> toComposeText({String initialText}) {
    return nuvigator.pushNamed<String>(
      pathWithPrefix(ComposerRoutes.composeText),
      arguments: {
        'initialText': initialText,
      },
    );
  }

  Future<String> pushReplacementToComposeText<TO extends Object>(
      {String initialText, TO result}) {
    return nuvigator.pushReplacementNamed<String, TO>(
      pathWithPrefix(ComposerRoutes.composeText),
      arguments: {
        'initialText': initialText,
      },
      result: result,
    );
  }

  String helpDeepLink() =>
      encodeDeepLink(pathWithPrefix(ComposerRoutes.help), <String, dynamic>{});
  Future<void> toHelp() {
    return nuvigator.pushNamed<void>(
      pathWithPrefix(ComposerRoutes.help),
    );
  }

  Future<void> pushReplacementToHelp<TO extends Object>({TO result}) {
    return nuvigator.pushReplacementNamed<void, TO>(
      pathWithPrefix(ComposerRoutes.help),
      result: result,
    );
  }

  Future<void> pushAndRemoveUntilToHelp<TO extends Object>(
      {@required RoutePredicate predicate}) {
    return nuvigator.pushNamedAndRemoveUntil<void>(
      pathWithPrefix(ComposerRoutes.help),
      predicate,
    );
  }

  Future<void> popAndPushToHelp<TO extends Object>({TO result}) {
    return nuvigator.popAndPushNamed<void, TO>(
      pathWithPrefix(ComposerRoutes.help),
      result: result,
    );
  }
}

extension ComposerRouterScreensAndRouters on ComposerRouter {
  Map<RoutePath, ScreenRouteBuilder> get _$screensMap {
    return {
      RoutePath(ComposerRoutes.composeText, prefix: false):
          (RouteSettings settings) {
        final args = ComposeTextArgs.parse(settings.arguments);
        return composeText(initialText: args.initialText);
      },
      RoutePath(ComposerRoutes.help, prefix: false): (RouteSettings settings) {
        return help();
      },
    };
  }
}
