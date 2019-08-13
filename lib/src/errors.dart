class RouteNotFoundException implements Exception {
  RouteNotFoundException(this.routeName) : assert(routeName != null);

  final String routeName;

  @override
  String toString() => 'RouteNotFoundException(routeName: $routeName)';
}
