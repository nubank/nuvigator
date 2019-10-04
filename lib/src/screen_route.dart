class ScreenRoute<T extends Object, R extends Object> {
  ScreenRoute(this.routeName, [this.params]);

  final String routeName;
  final T params;
}
