# Nuvigator Documentação da Next API

Nuvigator está passando por uma grande reformulação em sua API, para ser capaz de fornecer um modo mais dinâmico e fácil de
experiência do usuário. Os principais recursos funcionais do Nuvigator serão mantidos e aprimorados, mas a API de desenvolvimento
irá mudar drasticamente. No momento, ambas as APIs (legacy e next) podem coexistir, mas é preferível que você utilize a NEXT API
ao desenvolver novos fluxos.

## Começo simples

O mais simples que você pode obter:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nuvigator App',
      builder: Nuvigator.routes(
        initialRoute: 'home',
        screenType: materialScreenType,
        routes: [
          NuRouteBuilder(path: 'home', builder: (_, __, ___) => HomeScreen()),
          NuRouteBuilder(path: 'second', builder: (_, __, ___) => SecondScreen()),
        ],
      ),
    );
  }
}

Um exemplo mais completo:

```dart
import 'package:nuvigator/next.dart'; // import the next file instead of `nuvigator.dart`
import 'package:flutter/material.dart';

// Define a new NuRoute
class MyRoute extends NuRoute {
  @override
  String get path => 'my-route';

  @override
  ScreenType get screenType => materialScreenType;

  @override
  Widget build(BuildContext context, NuRouteSettings settings) {
    return MyScreen(
      onClick: () => nuvigator.open('next-route'),
    );
  }
}

// Define your NuRouter
class MyRouter extends NuRouter {
  @override
  String get initialRoute => 'my-route';

  @override
  List<NuRoute> get registerRoutes => [
    MyRoute(),
  ];
}

// Render
Widget build(BuildContext context) {
  return Nuvigator(
    router: MyRouter(),
  );
}

```

## Definindo Rotas

As rotas representam uma tela acessível em seu aplicativo, as rotas são representadas pela classe `NuRoute`. Cada `NuRoute`
deve pelo menos fornecer seu caminho completo e um método de construção. Existem outras propriedades opcionais que podem ser especificadas em
um `NuRoute`.

### NuRoute

Para criar sua rota, você deve estender a classe `NuRoute` e implementar (pelo menos) as substituições necessárias.

Exemplo:

```dart
class MyRoute extends NuRoute<NuRouter, MyArguments, MyReturn> {
  // Optional - metaData is a `NuRoute` attribute that allows you to provide metadata to the route.   
  // If not provided via super constructor, it will assume the default value `{}` which can receive data later.
  MyRoute() : super(metaData: {'foo': 'bar'});
  
  // Optional - If your Router enforces a synchronous initialization this should return an instance of a SynchronousFuture
  @override
  Future<bool> init(BuildContext context) async {
    // Do something
    return true; // return true to register the route
  }

  // Optional - will use the Router default if not provided
  @override
  ScreenType get screenType => materialScreenType;

  // Optional - converts deepLink params to MyArguments class
  @override
  ParamsParser<MyArguments> get paramsParser => _$paramsParser;

  // Optional - The the provided path should be matched as a prefix, instead of exact
  @override
  bool get prefix => false;

  // Path of this route
  @override
  String get path => 'my-route';

  // What this route will render
  @override
  Widget build(BuildContext context, NuRouteSettings settings) {
    // Inside the NuRouter subclass you have access to the `nuvigator` and `router` that this route is attached to.
    return MyScreen(
      onClick: () => nuvigator.open('next-route'),
    );
  }
}
```

Dentro da sua subclasse `NuRoute` você tem acesso ao` NuRouter` que está registrado e tipificado pelo argumento fornecido.
Você também pode usar o getter `NuRoute.nuvigator` para acessar o Nuvigator no qual este` NuRoute` está sendo apresentado.

### Caminho da rota

Os caminhos de rota são usados como DeepLinks (links profundos) e podem ter parâmetros de caminho para corresponder a eles. Os parâmetros de caminho serão extraídos e disponibilizados em `NuRouteSettings` fornecido para a função` NuRoute.build`.

Para declarar um parâmetro de caminho, você pode usar a sintaxe `:`, por exemplo:

```dart
String get path => 'myRoute/:pathParam'
```

Se você substituir a propriedade `prefix` em` NuRoute` para `true`, o caminho da rota será correspondido como prefixo (em termos de regex:` <yourPath>. * `). Isso pode ser útil se você tiver um Nuvigator aninhado que corresponderá ao caminho completo, tornando possível a navegação Deep Link aninhada.

### NuRouteSettings

Esta classe é uma subclasse do Flutter `RouteSettings` regular, mas inclui informações extras e detalhes do Deep Link correspondente ao Caminho da Rota. `NuRouteSettings` aceita um tipo genérico que diz respeito à classe que contém os argumentos analisados da rota.

Na classe `NuRoute`, você pode uma função` NuRoute.paramsParser` que receberá parâmetros brutos em `Map <String, dinâmico>` e deve retornar uma instância da classe Arguments declarada em sua tipagem de subclasse `NuRoute`.

### Inicialização do NuRoute

Cada `NuRoute` pode substituir o método` init (BuildContext context) `, que permite uma inicialização assíncrona de
quando seu `Nuvigator` correspondente é apresentado pela primeira vez.

**Importante**: A função `init` será executada quando o` Nuvigator` no qual este `NuRoute` está contido estiver
apresentado, e não quando o `NuRoute` é apresentado.

Você pode usar esta função para buscar algumas informações ou preparar um estado comum que precisará ser usado quando a rota
vai ser apresentado.

Enquanto todos os `NuRoute`s estão inicializando, um` loadingWidget` (fornecido pelo `Nuvigator` correspondente` NuRouter`) está indo
a ser apresentado.

### NuRouteBuilder

Você pode definir rotas inline usando um `NuRouteBuilder` esta abordagem é geralmente mais adequada para fluxos menores ou rotas
que não requerem nenhum tipo de processo de inicialização.

Exemplo:

```dart
import 'package:nuvigator/next.dart';

class MyRouter extends NuRouter {

  @override
  String get initialRoute => 'my-route-path';

  @override
  List<NuRoute> get registerRoutes => [
        NuRouteBuilder(
          path: 'my-route-path',
          screenType: materialScreenType,
          builder: (context, route, settings) => Container(),
        ),
      ];

}
```

## Routers

Módulos são um agrupamento de `NuRoute`s, são fornecidos ao` Nuvigator` como seu controlador. `NuModules` pode
implementar funções de inicialização personalizadas e configurar-se corretamente antes que o `Nuvigator` seja apresentado.

### NuRouter

Para criar seu roteador, você deve estender a classe `NuRouter` e implementar os métodos necessários.

```dart
class MyRouter extends NuRouter {

  // The initialRoute path that should be rendered by this Router Nuvigator
  @override
  String get initialRoute => 'home';

  // The list of NuRoutes that will be available in this Router.
  // Important: This method should return a new instance of the NuRoute, do not re-utilize instances
  @override
  List<NuRoute> get registerRoutes => [

  ];

  // Optional - Default ScreenType to be used when a route does not specify
  @override
  ScreenType get screenType => materialScreenType;

  // Optional - Custom initialization function of this Router
  @override
  Future<void> init(BuildContext context) {
    return SynchronousFuture(null);
  }

  // Optional - A function to wrap the `builder` function of the NuRoutes registered in the NuRouter.
  // This function runs one time for each route, and not one time for the entire NuRouter.
  Widget buildWrapper(
      BuildContext context,
      Widget child,
      NuRouteSettings settings,
      NuRoute nuRoute,
      ) =>
      child;

  // Optional (defaults to true) - Enables/Disables support for asynchronous initialization (will display the loading widget)
  @override
  bool get awaitForInit => true;

  // Optional - If asynchronous initialization is enabled, the widget will be rendered while the Router/Routes initialize
  @override
  Widget get loadingWidget => Container();

  // Optional - If no Route is found for the requested deepLink then this function will be called
  @override
  DeepLinkHandlerFn get onDeepLinkNotFound => null

  // Optional - If the Router initialization fails this function will be called, and it should return a Widget to be rendered instead of the Nuvigator
  Widget onError(Error error, NuRouterController controller) => null;

  // Optional - Register legacy NuRouters
  @override
  List<INuRouter> get legacyRouters => [

  ];
}
```

### NuRouter Inicialização e carregamento

Semelhante à inicialização de `NuRoute`, o` NuRouter` pode realizar alguma inicialização assíncrona quando é `Nuvigator`
é apresentado pela primeira vez. Durante a inicialização, o `loadingWidget` será renderizado em vez do Nuvigator.

Se por alguma razão você não quiser suportar a inicialização assíncrona, você pode sobrescrever o getter `awaitForInit`, e todos os métodos init do NuRoute e o próprio init do NuRoute precisarão retornar um` SynchronousFuture`.

### NuRouterBuilder

Da mesma forma que você pode definir `NuRoute`s inline, você pode fazer o mesmo com um` NuRouter`.

```dart
class MyWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Nuvigator(
      router: NuRouterBuilder(
        initialRoute: 'home',
        routes: [
          HomeRoute(),
          MyRoute(),
        ],
      ),
    );
  }
}
```

Você pode combinar `NuRouterBuilder` com` NuRouteBuilder` para alcançar uma abordagem completamente inline e dinâmica.

## Nuvigator

`Nuvigator` é uma subclasse` Navigator` que oferece recursos de navegação aninhados e melhorias de forma transparente.
Cada `Nuvigator` tem um` NuRouter` correspondente que é responsável por controlar sua lógica de roteamento. Fora isso,
um `Nuvigator` deve se comportar de forma muito semelhante a um` Navigator` normal.

### Nested Behaviors

Grande parte do que o Nuvigator faz está relacionado a cenários em que você aninha o Nuvigators.

**Abrindo DeepLinks**

Ao tentar abrir um deepLink, o Nuvigator tentará encontrar uma rota que corresponda ao deepLink fornecido do Nuvigator mais próximo até o raiz. Isso permite chamar deepLink de qualquer lugar em seu aplicativo, sem a necessidade de saber o quão profundamente aninhada sua tela está em relação ao Nuvigator/Roteador que pode exibir o deepLink solicitado.

**Popping Screens**

Se você estiver dentro de um Nuvigator aninhado e chamar o método `.pop` (ou variações), em vez de não fazer nada, ele fechará o Nuvigator aninhado, retornando ao pai. Isso permite a navegação transparente entre fluxos aninhados.

Outro ponto relevante aqui é que o valor passado para a função `.pop`, será passado downstream, fazendo com que seu fluxo aninhado retorne este valor para a tela que solicitou sua abertura.

**Botão de voltar no Android**

Quando o botão Voltar do Android é pressionado, o Nuvigator garantirá que apenas o Nuvigator mais profundo responda a ele, abrindo sua tela atual (em vez do Root Nuvigator)

**Animações Hero**

O Nuvigator vem com suporte integrado para animações Here que acontecem entre diferentes níveis de Nuvigators aninhados.

### Navegação

Prefira usar o método `NuvigatorState.open` quando quiser navegar para outra rota usando seu deepLink. Caso o deepLink contenha um esquema (`nuapp://my-route`,`nuapp://` é a parte do esquema aqui), ele será removido e não considerado como parte do deepLink para fins de navegação.

Exemplo:

```dart
// Gets your NuvigatorState instance (can be obtained from inside NuRouters/NuRoutes without the need of context)
final nuvigator = Nuvigator.of(context);
final result = await nuvigator.open<String>('nuapp://next-screen');
```

`.open` aceite algumas opções além do próprio deepLink:

- pushMethod (padrão: DeepLinkPushMethod.Push)
Permite personalizar como a rota será enviada para a pilha de navegação, as opções disponíveis são: Push, PushReplacement, PopAndPush.

- screenType
Permite substituir o Tipo de Tela que será usado para apresentar a Rota a ser aberta.

- parameters
Parâmetros adicionais a serem passados para a rota (serão mesclados com os parâmetros de consulta + caminho)


### Nuvigator.routes

Fábrica auxiliar para criar `Nuvigator` a partir de uma lista de` NuRoute`s, assim como um `NuRouterBuilder`.

Exemplo:

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Nuvigator.routes(
      initialRoute: 'home',
      routes: [
          NuRouteBuilder(path: 'home', builder: (_, __, ___) => HomeScreen()),
          NuRouteBuilder(path: 'second', builder: (_, __, ___) => SecondScreen()),
      ],
    ),
  }
}
```

## ScreenTypes

ScreenType é a classe que o Nuvigator usa para ajudá-lo a definir como seu NuRoute será apresentado. Ele atua como um adaptador entre o Widget Builder e o Navigator Route a ser apresentado. ScreenTypes permite definir transições / comportamento de apresentação do cliente de maneira declarativa. Por padrão, o Nuvigator fornece dois ScreenTypes padrão:

- MaterialScreenType
- CupertinoScreenType

Mas você pode criar seus próprios ScreenTypes estendendo a classe `ScreenType` e implementando o método` toRoute`. Este método deve retornar uma subclasse `Route`, uma funcionalidade adicional é o mixin` NuvigatorPageRoute`, que pode ser usado para melhorar a percepção da pilha de `PageRoute`s que o implementam, quando dentro do Nuvigators. Um exemplo de comportamento de ScreenType personalizado pode ser encontrado abaixo:

```dart
class _NuMaterialPageRoute<T> extends MaterialPageRoute<T> with NuvigatorPageRoute<T> {
  _NuMaterialPageRoute({
    @required WidgetBuilder builder,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
          builder: builder,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        );
}

class MaterialScreenType extends ScreenType {
  const MaterialScreenType();

  @override
  Route<T> toRoute<T extends Object>(
      WidgetBuilder builder, RouteSettings settings) {
    return _NuMaterialPageRoute(
      builder: builder,
      settings: settings,
    );
  }
}
```

## Interoperabilidade Legacy

A Next API oferece uma maneira de interoperar com a API de roteador legada (LEgacy API), o que pode facilitar a migração do projeto a ser
feito por partes.

Apenas registra seus `NuRouter`s legados sob o getter` legacyRouters` na nova classe `NuRouter`.

```dart
import 'package:nuvigator/next.dart';

class MyRouter extends NuRouter {
  // ...

  List<INuRouter> get legacyRouters => [
    MyLegacyRouter(),
  ];

// ...
}
```

Isso garantirá que, quando nenhuma rota for encontrada usando a nova API (para deepLinks e routeNames), a API antiga será
usado para tentar localizá-lo.
