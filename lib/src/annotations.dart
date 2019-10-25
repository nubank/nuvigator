/// Annotation used to define a router
///
/// This annotation is used by the code generator to identify the class as a
/// router and start the analysis of code generation.
///
/// By default the [NuRouter] generates all files with the class name where the
/// annotation is used, for example:
///
/// @NuRouter()
/// class MyRouter {}
///
/// The generated files will be:
///
/// class MyRouterRoutes {
///   static const myNuRoute = 'myRouter/myNuRoute';
/// }
///
/// MyRouterNavigation get myRouterNavigation => MyRouterNavigation.of(context);
///
/// You can specify the generated names using the argument [routerName] and the
/// [routeNamePrefix]. Here an example:
///
/// @NuRouter(routerName: 'Custom', routeNamePrefix: 'customPrefix/')
/// class MyRouter {}
///
/// The generated files will be:
///
/// class CustomRoutes {
///   static const myNuRoute = 'customPrefix/custom/myNuRoute';
/// }
///
/// CustomNavigation get customNavigation => CustomNavigation.of(context);
///
/// Obs: The [routeNamePrefix] is only used by the routes class to compose the
/// route names.
class NuRouter {
  const NuRouter({this.routerName, this.routeNamePrefix});

  final String routerName;
  final String routeNamePrefix;
}

class NuRoute {
  const NuRoute({this.deepLink, this.routeName, this.pushMethods});

  final String deepLink;
  final String routeName;
  final List<PushMethodType> pushMethods;
}

/// Enum to represent the push methods available on nuvigator
///
/// Check the [NuRoute] class to understand how this enum can be useful.
enum PushMethodType { push, pushReplacement, popAndPush, pushAndRemoveUntil }
