part of 'pizza_bloc.dart';

@immutable
abstract class PizzaEvent {}
abstract class EditPizza extends PizzaEvent {
  final int pizza;

  EditPizza(this.pizza);
}

class OpenPizzaCatalog extends PizzaEvent {

}
class AddPizzaToCatalog extends PizzaEvent {

}
class SaveCatalog extends PizzaEvent {

}

class AddBalance extends EditPizza {
  AddBalance(int pizza) : super(pizza);
}
class TurnDownBalance extends EditPizza {
  TurnDownBalance(int pizza) : super(pizza);
}
class NameChanged extends EditPizza {
  final String newName;
  NameChanged(int pizza,{required this.newName}) : super(pizza);
}
class PriceChanged extends EditPizza {
  final int newPrice;
  PriceChanged(int pizza,{required String newPrice}) : newPrice = int.parse(newPrice), super(pizza);
}
class AssertChanged extends EditPizza {
  final String newAssert;
  AssertChanged(int pizza,{required this.newAssert}) : super(pizza);
}


class OpenPrise extends PizzaEvent {

}
class AddPizzaToBasket extends PizzaEvent {
  final int pizza;

  AddPizzaToBasket(this.pizza);
}

class OpenBasket extends PizzaEvent {

}
class OrderBasket extends PizzaEvent {

}
class EditNumberBasket extends PizzaEvent {
  final int pizza;
  final int number;

  EditNumberBasket(this.pizza, {required this.number});
}


