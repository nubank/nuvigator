# Router Composition

Nuvigator is made to be able to handle Apps with lots of Routes and complex hierarchies, for this reason Router composition
is a central concept of how to organize your application routes. In this document we are going to explain in details the
various possible ways to compose Router together, and how wrapping behaves in each one of they.

## Grouped Routers

Grouped Routers is the pattern of basically merging Routes from one Router into another. This can be archived by using
the `@NuRouter` annotation into fields of a Router.

Example:
```dart
@NuRouter()
class Example1Router extends BaseRouter {
  ScreenRoute screenOneRoute = ScreenRoute(...);

  @override
  Map<RouteDef, ScreenRouteBuilder> get screensMap => _$example1ScreensMap(this);
}

@NuRouter()
class Example2Router extends BaseRouter {
  ScreenRoute screenTwoRoute = ScreenRoute(...);

  @override
  Map<RouteDef, ScreenRouteBuilder> get screensMap => _$example2ScreensMap(this);
}

@NuRouter()
class ExampleMainRouter extends BaseRouter {
  
  @NuRouter()
  final Example1Router example1Router = Example1Router();
  
  @NuRouter()
  final Eample2Router example2Router = Example2Router();
  
  @override
  Map<RouteDef, ScreenRouteBuilder> get screensMap => _$exampleMainScreensMap(this);
  @override
  List<Router> routers = _$exampleMainRoutersList(this);
}
```

In this case the behavior would be the same as the `screenOneRoute` and `screenTwoRoute` be placed directly into the 
`ExampleMainRouter` (with exception of generated features that would be named after the original Router declaration).

The Grouped Router pattern is useful when you want to split Routes into smaller Routers to be easier to manage and operate.
While keeping the navigation behavior of presenting they on the same Nuvigator as the `ExampleMainRouter` (not nested ones).

Options declared on the parent Router (`ExampleMainRouter`) such as `deepLinkPrefix` and `screensWrapper` are also going to be applied
into it's sub-Routers, so it's also an useful pattern to avoid code repetition when wanting to group deepLinks, and/or
provide data into the context of all child Routes.

## FlowRoutes

`FlowRoutes` are a variation of `ScreenRoute` that is used to declare nested flows inside a Router. This should be used 
when you desire to have a Route that would expand into a self-contained nested flow.

The usage of the `FlowRoute` is the same as an `ScreenRoute` with the difference that it would receive a Nuvigator, instead
of a builder function.

```dart
@NuRouter()
class NestedExampleRouter extends BaseRouter {
  ScreenRoute screenTwoRoute = ScreenRoute(...);
}

@NuRouter()
class ExampleMainRouter extends BaseRouter {
  
  @NuRouter()
  final Example1Router example1Router = Example1Router();
  
  @NuRouter()
  final Eample2Router example2Router = Example2Router();

  FlowRoute<NestedExampleRouter, void> nestedExampleFlow = FlowRoute(
    nuvigator: Nuvigator(
      router: NestedExampleRouter(),
      initialScreen: ...,
    ), 
  );

  @override
  Map<RouteDef, ScreenRouteBuilder> get screensMap => _$exampleMainScreensMap(this);
  @override
  List<Router> routers = _$exampleMainRoutersList(this);
}
```

When the `FlowRoute` is reached it will open a new Route with the provided nested Nuvigator. Arguments passed to the original route
will also be available for the nested flow to use at anytime.

You can find below a routing tree representation of the example provided, right after each Route it's described which Router
is the one that declared and provided the Route to it's corresponding Nuvigator. 

```
Root
|- Nuvigator (ExampleMainRouter)
   |- screenOneRoute (From: Example1Router)
   |- screenTwoRoute (From: Example2Router)
   |- nestedExampleFlow: (From: ExampleMainRouter) 
      Nuvigator (NestedExampleRouter)
      |- NestedRoute1 (From: NestedExampleRouter)
      |- NestedRoute2 (From: NestedExampleRouter)
```

It's important to note that Router that are declared only for `FlowRoute` are not going to have it's deepLinks and routes
considered in the global navigation, they are instantiated and exists just withing they self-contained context of the `FlowRoute`
that they were presented.

If you need nested flows that are dynamic instantiated and can interact with the global routing mechanism, you probably need
to use the `FlowRouter` mechanism. 

## FlowRouters

`FlowRouter` is a special kind of Grouped Router that inherits properties from flows. It can me considered a mixed solution
between both approaches described above. While powerful they require attention when being used, given that the Routing can 
get confusing when abusing from they.

`FlowRouter` is going to place all Routes into the same tree as the parent Router, just like Grouped Routers, however, when
one of it's Routes is reached, it will dynamically create a new Flow (Nuvigator), with the reached Route being the first screen
of the Flow, and having the provided Router and the nested Nuvigator Router. This allows for creating flows that do not have
a defined first screen, or even mid-flow deepLinking.

The usage is very similar to a grouped Router, with the exception that you should wrap the desired Router into a `FlowRouter`,
and provide any additional options to it.

```dart
@NuRouter()
  final sampleOneRouter = FlowRouter(
    SampleOneRouter(),
    screensType: materialScreenType,
  );
```
