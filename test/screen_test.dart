import 'package:flutter_test/flutter_test.dart';
import 'package:nuvigator/nuvigator.dart';
import 'package:nuvigator/src/screen_types/cupertino_screen_type.dart';
import 'package:nuvigator/src/screen_types/material_screen_type.dart';

import 'helpers.dart';

void main() {
  test('defaultWrapperFn return the own widget', () {
    final widget = TestWidget();
    expect(defaultWrapperFn(null, widget), widget);
  });

  group('helper build methods for Screen', () {
    test('on cupertino', () {
      expect(Screen.cupertino((sc) => null).screenType, cupertinoScreenType);
    });

    test('on material', () {
      expect(Screen.material((sc) => null).screenType, materialScreenType);
    });
  });


}
