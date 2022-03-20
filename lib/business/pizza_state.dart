part of 'pizza_bloc.dart';

@immutable
abstract class PizzaState extends Equatable {
  final List<Pizza> pizzas;
  final List<PizzaInBasket>? pizzasBasket;

  const PizzaState(this.pizzas, this.pizzasBasket);
}

class PizzaCatalogState extends PizzaState {
  const PizzaCatalogState({required List<Pizza> pizzas}) : super(pizzas,null);

  @override
  List<Object?> get props => [pizzas];
}

class PizzaInitial extends PizzaState {
  const PizzaInitial({required List<Pizza> pizzas}) : super(pizzas,null);

  @override
  List<Object?> get props => [pizzas];
}

class PizzaBasketInitial extends PizzaState {
  final int total;
  const PizzaBasketInitial({required List<Pizza> pizzas,required List<PizzaInBasket> pizzasBasket,required this.total}) : super(pizzas,pizzasBasket);

  @override
  List<Object?> get props => [total, pizzasBasket];
}
