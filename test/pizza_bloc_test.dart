import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sgmk_test_task/business/pizza_bloc.dart';
import 'package:sgmk_test_task/model/pizza.dart';
import 'package:sgmk_test_task/model/pizza_in_basket.dart';

class MockBoxPizza<Pizza> extends Mock implements Box<Pizza> {
}
class MockBoxPizzaInBasket<PizzaInBasket> extends Mock implements Box<PizzaInBasket> {
}

main() {
  late MockBoxPizza<Pizza> boxPizza;
  late MockBoxPizzaInBasket<PizzaInBasket> boxPizzaInBasket;
  late PizzaBloc bloc;
  Iterable<Pizza> pizzas = [Pizza(name: "pizza1",price: 9,balance: 6),Pizza(name: "pizza2",price: 4,balance: 2),Pizza(name: "pizza3",price: 7,balance: 1)];
  Iterable<PizzaInBasket> pizzaInBasket = [PizzaInBasket(pizza: Pizza(name: "pizza2",price: 4,balance: 2))];
  setUp(() {
    boxPizza = MockBoxPizza();
    boxPizzaInBasket = MockBoxPizzaInBasket();
    when(() => boxPizza.values)
        .thenReturn(pizzas);
    when(() => boxPizzaInBasket.values)
        .thenReturn(pizzaInBasket);
    bloc = PizzaBloc(boxPizza,boxPizzaInBasket);
  });


  group('Test pizza state', () {
    test('initial state', () {
      final pizzaBloc = PizzaBloc(boxPizza,boxPizzaInBasket);
      expect(
          pizzaBloc.state,
          const PizzaInitial(pizzas: [])
      );
    });
  });

  group('Test pizza bloc', () {
    blocTest<PizzaBloc, PizzaState>(
      'test Basket',
      setUp: () {
        when(() => boxPizza.values)
            .thenReturn(pizzas);
        when(() => boxPizza.close())
            .thenAnswer((_) => Future<void>.value());
        when(() => boxPizzaInBasket.values)
            .thenReturn(pizzaInBasket);
        when(() => boxPizzaInBasket.close())
            .thenAnswer((_) => Future<void>.value());
      },
      build: () => bloc,
      act: (bloc) => bloc.add(OpenBasket()),
      expect: () => <PizzaState>[
        PizzaBasketInitial(pizzasBasket: pizzaInBasket.toList(), total: 4, pizzas: [])
      ],
    );
  });

  group('Test pizza bloc', () {
    blocTest<PizzaBloc, PizzaState>(
      'test Catalog',
      setUp: () {
        when(() => boxPizza.values)
            .thenReturn(pizzas);
        when(() => boxPizza.close())
            .thenAnswer((_) => Future<void>.value());
        when(() => boxPizzaInBasket.values)
            .thenReturn(pizzaInBasket);
        when(() => boxPizzaInBasket.close())
            .thenAnswer((_) => Future<void>.value());
      },
      build: () => bloc,
      act: (bloc) => bloc.add(OpenPizzaCatalog()),
      expect: () => <PizzaState>[
        PizzaCatalogState(pizzas: pizzas.toList())
      ],
    );
  });
}
