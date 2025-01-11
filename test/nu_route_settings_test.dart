import 'package:flutter_test/flutter_test.dart';
import 'package:nuvigator/src/nu_route_settings.dart';

void main() {
  group('NuRouteSettings', () {
    test('should correctly merge parameters', () {
      final settings = NuRouteSettings(
        name: 'test',
        pathTemplate: '/test',
        scheme: 'https',
        queryParameters: {'q': 'query'},
        pathParameters: {'p': 'path'},
        extraParameters: {'e': 'extra'},
      );

      expect(settings.rawParameters, {
        'q': 'query',
        'p': 'path',
        'e': 'extra',
      });
    });

    test('should correctly compare two instances', () {
      final settings1 = NuRouteSettings(
        name: 'test',
        pathTemplate: '/test',
        scheme: 'https',
        queryParameters: {'q': 'query'},
        pathParameters: {'p': 'path'},
        extraParameters: {'e': 'extra'},
      );

      final settings2 = NuRouteSettings(
        name: 'test',
        pathTemplate: '/test',
        scheme: 'https',
        queryParameters: {'q': 'query'},
        pathParameters: {'p': 'path'},
        extraParameters: {'e': 'extra'},
      );

      expect(settings1, equals(settings2));
    });
  });
}
