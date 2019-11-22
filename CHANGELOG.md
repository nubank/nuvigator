# CHANGELOG

## 0.1.0+3
- Fix a bug when trying to call onDeepLinkNotfound

## 0.1.0+2
- Update pubspec.yaml dependencies versions

## 0.1.0+1
- Improve pub description and update packages

## 0.1.0
- [BREAKING] Major refactor and API revamp
- Create `Nuvigator` navigator widget
- Make `Hero` animations work
- `Screen` was renamed to `ScreenRoute`
- `FlowRoute` is a `ScreenRoute` for nested Nuvigators.
- Make `ScreenRoute` cary information about DeepLinks
- Make `GlobalRouter` able to be created with callbacks and a baseRouter 
- Add `cupertinoDialogScreenType` ScreenType
- Provide access to the `GlobalRouter` through `InheritedWidgets`
- Remove the need to extend the `GlobalRouter`
- Removal of `NavigationService` in favor of `ScreenRoute`
- Removal of `FlowRouter` in favor of nested `Nuvigators`
- Removal of `ScreenContext` in favor of `BuildContext`
- Added code generation for creating code from a base Router defined

## 0.0.4
- Fix transition animation when coming from native
- Fix transition animation when popping from flow

## 0.0.3
- `FlowRouter` type now extends `Object`
- The `arguments` of push methods was changed from `Map` to `Object`
- `ScreenWidget` now is generic to set args type (default is `Object`)

## 0.0.2
- Add `popUntil` to `NavigationService`

## 0.0.1
- Initial version
