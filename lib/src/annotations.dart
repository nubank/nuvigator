/// Annotation used to define a router
///
/// You can set a [routerName] and [routeNamePrefix].
///
/// This annotation is used by the code generator to identify a class as a
/// router and start the analysis of code generation.
///
/// By default, the [NuRouter] generates all the code with the class name where
/// the annotation is used, for example:
///
/// {@tool sample}
/// This sample shows how to create a [NuRouter].
///
/// ```dart
/// @NuRouter()
/// class HomeRouter {
///   @NuRoute()
///   ScreenRoute profile() => ScreenRoute(
///     builder: (context) => ProfileScreen(context),
///   );
/// }
/// ```
/// {@end-tool}
///
/// The generated code will be:
///
/// ```dart
/// class HomeRoutes {
///   static const profile = 'home/profile';
/// }
///
/// HomeNavigation get homeNavigation => HomeNavigation.of(context);
/// ```
///
/// You can specify the generated names using the argument [routerName] and the
/// [routeNamePrefix].
///
/// {@tool sample}
/// This sample shows how to create a [NuRouter] with a custom name and prefix.
///
/// ```dart
/// @NuRouter(routerName: 'Custom', routeNamePrefix: 'customPrefix/')
/// class HomeRouter {
///   @NuRoute()
///   ScreenRoute profile() => ScreenRoute(
///     builder: (context) => ProfileScreen(context),
///   );
/// }
/// ```
/// {@end-tool}
///
/// The generated codes will be:
///
/// ```dart
/// class CustomRoutes {
///   static const profile = 'customPrefix/custom/profile';
/// }
///
/// CustomNavigation get customNavigation => CustomNavigation.of(context);
/// ```
///
/// Obs: The [routeNamePrefix] is only used by the routes class to compose the
/// route names.
class NuRouter {
  const NuRouter({this.routerName});

  final String routerName;
}

/// Annotation used to define a route.
///
/// You can set a [deepLink], [pushMethods], and configure if it's a [prefix].
///
/// This annotation is used by the code generator to identify a method as a
/// route and start the analysis of code generation.
///
/// By default, the [NuRoute] generates all the code with the method name where
/// the annotation is used, for example:
///
/// {@tool sample}
/// This sample shows how to create a [NuRoute].
///
/// ```dart
///   @NuRoute()
///   ScreenRoute profile() => ScreenRoute(
///     builder: (context) => ProfileScreen(context),
///   );
/// ```
/// {@end-tool}
///
/// An example of generated code is:
///
/// ```dart
///   static const profile = '<routerName>/profile';
/// ```
///
/// You can change the name used on the generated codes setting the [routePath].
///
/// ```dart
/// NuRoute(routeName: 'custom')
/// ```
///
/// Another important prop is the [pushMethods], by default the [NuRoute] will
/// generate a method for all types of push. You can specify which methods you
/// need and avoid unused code.
class NuRoute {
  const NuRoute({this.deepLink, this.pushMethods, this.prefix = false});

  final String deepLink;
  final bool prefix;
  final List<PushMethodType> pushMethods;
}

/// Enum to represent the push methods available on nuvigator
///
/// Check the [NuRoute] class to understand how this enum can be useful.
enum PushMethodType { push, pushReplacement, popAndPush, pushAndRemoveUntil }
