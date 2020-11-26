import 'package:flutter_test/flutter_test.dart';

import 'nu_module_example.dart';

void main() {
  group('Test @nuRouteParser annotation', () {
    test('Should return an exact instance of FriendRequestRouteArgs from a map',
        () {
      final module = FriendRequestRouteExample();

      final argumentInstance = FriendRequestArgs()
        ..numberOfRequests = 5
        ..precision = 0.5
        ..name = 'RouteNameTesting'
        ..age = 99;

      final map = {
        'numberOfRequests': 5,
        'precision': 0.5,
        'name': 'RouteNameTesting',
        'age': 99,
      };

      expect(argumentInstance == module.parseParameters(map), true);
    });
  });
}
