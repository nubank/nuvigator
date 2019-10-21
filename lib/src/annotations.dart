class NuRouter {
  const NuRouter({this.routerName, this.routeNamePrefix});

  final String routerName;
  final String routeNamePrefix;
}

class NuRoute {
  const NuRoute({this.deepLink, this.routeName});

  final String deepLink;
  final String routeName;
}
