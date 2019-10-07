# CHANGELOG

## 0.1.0
- [BREAKING] Major refactor and API revamp
- Create `Nuvigator` navigator widget
- Make `Hero` animations work
- Make `Screen` cary information about DeepLinks
- Make `GlobalRouter` able to be created with callbacks and routers 
- Add `ScreenRoute` class for typed route navigation
- Add `cupertinoDialogScreenType` ScreenType
- Provide access to the `GlobalRouter` through `InheritedWidgets`
- Remove the need to extend the `GlobalRouter`
- Removal of `NavigationService` in favor of `ScreenRoute`
- Removal of `FlowRouter` in favor of nested `Nuvigators`
- Removal of `ScreenContext` in favor of `BuildContext`

## 0.0.3
- `FlowRouter` type now extends `Object`
- The `arguments` of push methods was changed from `Map` to `Object`
- `ScreenWidget` now is generic to set args type (default is `Object`)

## 0.0.2
- Add `popUntil` to `NavigationService`

## 0.0.1
- Initial version
