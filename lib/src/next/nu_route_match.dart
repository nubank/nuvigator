class NuRouteMatch<A> {
  NuRouteMatch({
    this.pathTemplate,
    this.path,
    this.nextPath,
    this.queryParameters,
    this.pathParameters,
    this.extraParameter,
    this.args,
  });

  final A args;
  final String pathTemplate;
  final String path;
  final String nextPath;
  final Map<String, dynamic> queryParameters;
  final Map<String, dynamic> pathParameters;
  final Map<String, dynamic> extraParameter;

  Map<String, String> get parameters => {
        ...queryParameters ?? {},
        ...pathParameters ?? {},
        ...extraParameter ?? {},
      };
}
