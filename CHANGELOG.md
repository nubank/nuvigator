# CHANGELOG

## 1.1.0
- Add the `ScreenTypeBuilder` class to allow the definition and creation of `ScreenTypes` in an ad-hoc manner
- Add the `screenType` parameter to the `NuvigatorState.open` method, allowing to override the `ScreenType` of a defined Route to be opened

## 1.0.0
- First stable release with NEXT API (check past beta changelog entries for details)

## 1.0.0-beta.12
- Add option in NuRouter to retry the initialization of the Router when it fails

## 1.0.0-beta.11
- Add option in NuRouter to provide an error handling function when the Router initialization fails

## 1.0.0-beta.10
- Fix extra arguments passing on the [NuvigatorState.open] method

## 1.0.0-beta.9
- Fix open method in order to transport params through actions

## 1.0.0-beta.8
- Fix the NuRouteSettings copy and fallback methods that were not considering the settings property

## 1.0.0-beta.7
- Allow specifying which push method to use when calling [NuvigatorState.open]

## 1.0.0-beta.6
- Fix the `NuRouterLoader` to re-instantiate the nuvigator only if the router change

## 1.0.0-beta.5
- Fix to use the screenType when the fallback one is not provided

## 1.0.0-beta.4
- Improvements on next API typings
- Improvements to next generator

## 1.0.0-beta.3
- Add `awaitForInit` option in the `NuRouter` to configure if it should support async initialization
- Fix router property name on `NuRoute`
- Make `loadingWidget` a getter method

## 1.0.0-beta.2
- Add support from Navigation coming from Native side on Next API
  - `INuRouter.getRoute` now accepts an optional `isFromNative` option
  - `NuvigatorState.open` now accepts an optional `isFromNative` option
- Remove default screenType from Nuvigator constructor

## 1.0.0-beta.1
- Fixed asserts on Nuvigator
- Add improved error message when a ScreenRoute is rendered without a ScreenType specified

## 1.0.0-beta.0+1
- Fix conflict between `Nuvigator` and `NuvigatorInner` key

## 1.0.0-beta.0
- Introduction of a new dynamic API (aka: `next`), more info can be found at it's own documentation
  - DeepLinks and RouteNames where unified under paths
  - New dynamic approach to define Routes and Routers
  - More info can be found at [here](doc/next.md)
- `initialDeepLink` and `initialRoute` have better error reporting and a more precise behavior.
  - Just the explicitly provided initialRoute is going to be used to find the Route.
- Nuvigator now relies on a interface type `INuRouter` instead of a concrete specific implementation
- `onScreenNotFound` method was removed
- Introduction of `NuvigatorState.open` in favor of `.openDeepLink`. This new method supports nested deepLink navigation.
- Old API can be considered deprecated from now on. Prefer using the `next` API on new projects.

## 0.7.2
- Fix problems caused by bump in `analyzer` dependency

## 0.7.1
- Update README
- Update pubspec.yaml to support analyzer up to version `0.41.0`

## 0.7.0
- [BREAKING] Rename classes to avoid conflicts with Flutter 1.22 Router Widget
  - `Router` was renamed to `NuRouter`
  - The `NuRouter` annotation was renamed to `nuRouter` const or `customNuRouter` function

## 0.6.2
- Fix NPE exception when a old instance of router tries calling some methods on it's nuvigator

## 0.6.1
- Fix a `NavigationObserver` error when the nuvigator is updated. Now we are reloading the `inheritableObservers` and `StateTracker` when has an update.

## 0.6.0
- Add support for typed screen arguments on deep links. In addition to `String`, we now support `int`, `double,` `bool`, and `DateTime`.

## 0.5.1
- Update ReCase version support to '>= 2.0.0 <3.1.0'

## 0.5.0
- Updates the codebase to flutter 1.17 (stable) version

## 0.4.6
- Support query parameters with dashes by converting them to camelCase

## 0.4.5
- Downgrade the analyzer dependency to '>=0.38.5 <0.40.0'

## 0.4.3
- Fix an exception when the args are null because are passed by the constructor

## 0.4.2
- Fix the `Nuvigator.of(context)` to start the search at the last state instead of root

## 0.4.1
- Make `initialDeepLink` work passing arguments to destination route

## 0.4.0
- Allow to pass an `initialDeepLink`
- Add new option to pop SystemNavigator on last screen of the Root Router

## 0.3.0
- **[BREAKING]** API Simplifications/Changes.
    - Removal of `ScreenWidget` and related generated classes.
    - Removal of `FlowRoute`, now you can use the default `ScreenRoute` and pass the Nuvigator to the builder function.
    - Removal of `GlobalRouter`, every `Router` had it's capabilities incorporated, you can override previous `GlobalRouter`
    properties directly in your topmost Router class, and pass it directly to the Nuvigator.
    - Removal of Nuvigator `initialArgs` auto-passing, now you should explicitly provide the arguments required to the
    nested nuvigator. The suggestion is to pass it to the Router constructor.
    - Removal of `FlowRouters`.
    - Nested Nuvigators will not have it's router exposed by the parent anymore.
    - Use extension methods to navigation methods in the Router. Instead of `ExampleNavigation.of(context).toRoute()`
    use `Router.of<ExampleRouter>(context).toExampleRoute()`.
    - Use of extension methods to `screensMap` and `routers` generator. Instead of passing this to the function, just call
    the private getter `_$screensMap` and `_$routers` in the `Router` class.
    - Unify `Router` and `BaseRouter`, instead of extending `BaseRouter` you should extend `Router` directly.
    - Rename `getDeepLinkPrefix` to `deepLinkPrefix`.
    - `initialRoute` is now a required argument to Nuvigator.
- **[IMPORTANT]** Router instances should be unique per Nuvigator. The same Router instance SHOULD NOT be shared by different
Nuvigator (we advise to create new instances together with the Nuvigator).
- A bug was fixed were the `maybePop` method was not consistent with the Android back button behavior. Now the expected
behavior is to always pop the Route of the active Nuvigator.
- Nuvigator now keeps track of it's Route stack.
- Added debug flag to Nuvigator to log all route transitions/changes.
- Observers management was moved into the state lifecycle to ensure that inheritableObservers are always going to be
considered.
- **[BUMP]** Updates to **Flutter 1.12.1**, resolves some deprecation warnings.
- A `toMap` getter was added to `Args*` classes to serialize them into `Map<String, Object>`.
- Added new mixin `NuvigatorRoute` that should be incorporated by `PageRoutes` used in custom `ScreenType`s. While this
mixin is optional, it will guarantee the correct behavior of Android's back button and also make nested Nuvigators Routes
present `AppBar` back buttons correctly based in the overall App state, and not only by the current Nuvigator. (The provided
screensTypes Material and Cupertino have already been update to include this new Mixin).
- Improvement of some error messages that could be misleading or produce unexpected error.

## 0.2.2
- Increase plugins version range

## 0.2.1
- Fix the bug when Android back button is pressed closing the app. Now,
  when the back button is pressed, the nuvigator will try to close the
  current page and will just close the app when doesn't have any pages to pop.

## 0.2.0
- Add `FlowRouter` back, compatible with the new API of nested Nuvigators
- Increase version constraint of `analyzer`

## 0.1.1
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
