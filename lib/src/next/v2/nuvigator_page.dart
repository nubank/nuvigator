// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
//
// import '../nu_route_match.dart';
// import '../nu_route.dart';
//
// class NuvigatorPage<A, T> extends Page<T> {
//   NuvigatorPage({this.module, this.nuRouteMatch})
//       : super(
//           name: nuRouteMatch.path,
//           arguments: nuRouteMatch.args,
//         );
//
//   final NuRoute module;
//   final NuRouteMatch<A> nuRouteMatch;
//
//   @override
//   Route<T> createRoute(BuildContext context) {
//     return module.getRoute(nuRouteMatch).toRoute(this);
//   }
// }
