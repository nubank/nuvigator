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

enum PushMethodType { push, pushReplacement, popAndPush, pushAndRemoveUntil }
