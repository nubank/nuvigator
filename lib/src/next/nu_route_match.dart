class NuRouteMatch<A> {
  NuRouteMatch({
    this.pathTemplate,
    this.path,
    this.nextPath,
    this.queryParameters,
    this.pathParameters,
    this.args,
  });
  final A args;
  final String pathTemplate;
  final String path;
  final String nextPath;
  final Map<String, String> queryParameters;
  final Map<String, String> pathParameters;

  Map<String, String> get parameters => {
        ...queryParameters ?? {},
        ...pathParameters ?? {},
      };
}
