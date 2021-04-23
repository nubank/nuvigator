import 'package:flutter/widgets.dart';

import 'next/v1/nu_router.dart';
import 'nu_route_settings.dart';
import 'nuvigator.dart';
import 'screen_route.dart';

typedef ScreenRouteBuilder = ScreenRoute<dynamic>? Function(
    RouteSettings settings);

typedef HandleDeepLinkFn = Future<dynamic> Function(INuRouter? router, Uri uri,
    [bool? isFromNative, dynamic? args]);

typedef ObserverBuilder = NavigatorObserver Function();

typedef WrapperFn = Widget Function(BuildContext context, Widget child);

typedef NuWidgetRouteBuilder<A extends Object, R extends Object>
    = Widget Function(BuildContext context, NuRouteBuilder<A, R> nuRoute,
        NuRouteSettings<A> settings);

typedef NuRouteParametersParser<A> = A Function(Map<String, dynamic>);

typedef NuInitFunction = Future<bool> Function(BuildContext context);

typedef ParamsParser<T> = T? Function(Map<String, dynamic> map);
