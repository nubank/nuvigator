import 'package:flutter/widgets.dart';

import '../nuvigator.dart';

typedef ScreenRouteBuilder = ScreenRoute<dynamic> Function(
    RouteSettings settings);

typedef HandleDeepLinkFn = Future<dynamic> Function(INuRouter router, Uri uri,
    [bool isFromNative, dynamic args]);

typedef ObserverBuilder = NavigatorObserver Function();

typedef WrapperFn = Widget Function(BuildContext context, Widget child);
