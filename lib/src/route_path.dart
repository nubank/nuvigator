import 'dart:ui';

import 'package:flutter/foundation.dart';

class RoutePath {
  RoutePath(this.path, {this.prefix = false});

  final String path;
  final bool prefix;

  RoutePath copyWith({String path, bool prefix}) {
    return RoutePath(
      path ?? this.path,
      prefix: prefix ?? this.prefix,
    );
  }

  @override
  int get hashCode => hashList([path.hashCode, prefix.hashCode]);

  @override
  bool operator ==(Object other) {
    return other is RoutePath && other.path == path && other.prefix == prefix;
  }

  @override
  String toString() =>
      '${objectRuntimeType(this, 'RoutePath')}("$path", prefix: "$prefix")';
}
