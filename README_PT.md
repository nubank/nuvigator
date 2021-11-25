# Nuvigator

[![CircleCI](https://circleci.com/gh/nubank/nuvigator/tree/master.svg?style=svg)](https://circleci.com/gh/nubank/nuvigator/tree/master)
[![Pub](https://img.shields.io/pub/v/nuvigator.svg)](https://pub.dartlang.org/packages/nuvigator)

Pacote para roteamento e navegação.

## O que é

Nuvigator provê uma poderosa abstração de roteamento sobre os próprios navegadores do Flutter. Modele fluxos de navegação complexos usando uma abordagem principalmente declarativa e concisa, sem precisar se preocupar com vários comportamentos complicados que o Nuvigator trata para você.

Nuvigator pode ajudar você com:

- Grande/Modular Apps: Onde você precisa ter uma API unificada para registrar as rotas e projetar a relação entre elas
- Navegação aninhada: Quando você deseja ter um Navigator aninhado / filho dentro do seu aplicativo, criando o conceito de fluxos autocontidos  - Handles Navigation thought Nuvigator ins your Widget Tree, not need to know where your route is declared
  - Lida com o comportamento pop quando um navegador (Navigator) aninhado chega ao seu fim, é capaz de encaminhar os resultados pop de forma transparente para o chamador subjacente, auxiliares do provedor para lidar com a navegação aninhada
  - Lida com animação / transição Hero entre navegadores aninhados
  - Manipula o botão Voltar do Android corretamente em navegadores aninhados
  - Melhore o suporte para PageRoutes aninhados com o mixin NuvigatorPageRoute
- Usando DeepLinks: você deseja navegar dentro de seu aplicativo usando DeepLinks, com suporte para parâmetros de caminho e parâmetros de consulta
- Uma API declarativa e fácil de usar para declarar e compor rotas juntas

[**Para a documentação da NEXT API**](./doc/next.md)
> Concentre-se em fornecer uma API mais flexível, fácil e dinâmica para declarar navegação e roteamento

[**Para a documentação da API legada**](./doc/legacy.md)
> Uma API baseada em métodos e geradores de tipo estático. É considerado obsoleto e eventualmente será removido

## Começo rápido

O mais simples que você pode obter:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nuvigator App',
      builder: Nuvigator.routes(
        initialRoute: 'home',
        routes: [
          NuRouteBuilder(path: 'home', builder: (_, __, ___) => HomeScreen()),
          NuRouteBuilder(path: 'second', builder: (_, __, ___) => SecondScreen()),
        ],
      ),
    );
  }
}
```

Um exemplo mais completo:

```dart
import 'package:nuvigator/next.dart'; // importe o próximo arquivo em vez de `nuvigator.dart`
import 'package:flutter/material.dart';

// Defina a nova NuRoute
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

// Defina a sua NuRouter
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

# Licença
[Apache License 2.0](LICENSE)
