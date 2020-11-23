import 'package:flutter_test/flutter_test.dart';
import 'package:nuvigator/src/deeplink.dart';

void main() {
  group('on DeepLinkParser class', () {
    final parser = DeepLinkParser(template: 'my-route/:myArgument');
    test('on getting the path params', () {
      final result =
          parser.getPathParams('my-route/something?another-one=hello');
      expect(result, {
        'myArgument': 'something',
      });
    });

    test('on getting the query params', () {
      final result =
          parser.getQueryParams('my-route/something?another-one=hello');
      expect(result, {
        'another-one': 'hello',
        'anotherOne': 'hello',
      });
    });

    test('on getting the deepLink schema', () {
      final result = parser.getScheme('nuapp://test');
      expect(result, 'nuapp');
    });

    test('when matching against deepLinks', () {
      expect(true, parser.matches('my-route/something'));
      expect(true, parser.matches('nuapp://my-route/some?route=http://bla2'));
      expect(true, parser.matches('my-route/something?a=parameter'));
      expect(false, parser.matches('other-route/something'));
      expect(false, parser.matches('my-route/something/nope'));
      expect(false, parser.matches('my-route/nope/something'));
    });

    test('extracting parameters from deepLink', () {
      final result =
          parser.getParams('nuapp://my-route/something?another-one=hello');
      expect(result, {
        'myArgument': 'something',
        'another-one': 'hello',
        'anotherOne': 'hello'
      });
    });
  });
}
