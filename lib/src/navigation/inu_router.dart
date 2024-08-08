import 'package:flutter/material.dart';
import 'package:nuvigator/src/navigation/nuvigator_state.dart';

import '../../next.dart';

abstract class INuRouter {
  /// When the [NuvigatorState] is initialized this method is called on the respective
  /// [INuRouter] to register it's reference.
  void install(NuvigatorState nuvigator);

  /// When the [NuvigatorState] disposes, this method is called on the respective
  /// [INuRouter] to perform any cleanup work required.
  void dispose();

  /// In case this [INuRouter] is not able to provide a [Route] for the requested
  /// deepLink, and this property is different from null, it will be called to perform
  /// a fallback execution
  HandleDeepLinkFn? onDeepLinkNotFound;

  /// When a new deepLink is requested to be opened the [Nuvigator] this method is
  /// called in the respective [INuRouter] to retrieve the [Route] to be presented
  Route<T>? getRoute<T>({
    required String deepLink,
    Object? parameters,
    bool isFromNative = false,
    ScreenType? fallbackScreenType,
    ScreenType? overrideScreenType,
  });
}