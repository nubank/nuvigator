import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:nuvigator/src/screen_route.dart';

import '../nu_route.dart';
import 'nuvigator_page.dart';

class NuRouteConfig {}
//
// abstract class NuRouterDelegate extends RouterDelegate<NuRouteConfig>
//     with ChangeNotifier, PopNavigatorRouterDelegateMixin<NuRouteConfig> {
//   final List<Page> _pages = [];
//
//   GlobalKey<NavigatorState> _navigatorKey;
//
//   @override
//   GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
//   NuRouterDelegate nuvigator;
//   List<NuRouteModule> _modules;
//
//   Widget loadingWidget(BuildContext _) => Container();
//
//   List<NuRouteModule> get modules;
//
//   String get initialRoute;
//
//   Future<void> init(BuildContext context) async {
//     final modulesToRegister = <NuRouteModule>[];
//     for (final module in modules) {
//       final shouldRegister = await module.init(context);
//       if (shouldRegister) {
//         modulesToRegister.add(module);
//       }
//     }
//     _modules = modulesToRegister;
//   }
//
//   // Ignores the entire current stack and replaces just by this deepLink
//   void setDeepLinks(List<String> deepLink) {}
//
//   ScreenRoute<R> getRoute<R>(BuildContext context, RouteSettings settings) {
//     for (final module in _modules) {
//       final match = module.getRouteMatch(settings.name);
//       if (match != null) {
//         return module.getRoute(match);
//       }
//     }
//     return null;
//   }
//
//   Future<R> openDeepLink<R>(String deepLink) async {
//     for (final module in _modules) {
//       final routeMatch = module.getRouteMatch(deepLink);
//       if (routeMatch != null) {
//         final completer = Completer<dynamic>();
//         final page = NuvigatorPage<dynamic, dynamic>(
//           module: module,
//           nuRouteMatch: routeMatch,
//           // onPop: (result) {
//           //   completer.complete(result);
//           // },
//         );
//         _pages.add(page);
//         return completer.future; // Simulate the pop return value behavior
//       }
//     }
//     return null; // No module matched, how we handle this?
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: init(context),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           return Navigator(
//             key: _navigatorKey,
//             initialRoute: initialRoute,
//             onPopPage: (route, dynamic result) {
//               route.didPop(result);
//               final Page<dynamic> page = route.settings;
//               _pages.removeWhere((element) => element.key == page.key);
//               notifyListeners();
//               return true;
//             },
//             pages: _pages,
//           );
//         } else {
//           return loadingWidget(context);
//         }
//       },
//     );
//   }
//
//   @override
//   Future<bool> popRoute() async {
//     _pages.removeLast();
//     notifyListeners();
//     return true;
//   }
//
//   @override
//   Future<void> setNewRoutePath(NuRouteConfig configuration) {
//     throw UnimplementedError();
//   }
// }
