import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';
import 'package:sgmk_test_task/model/pizza.dart';
import 'package:sgmk_test_task/model/pizza_in_basket.dart';

part 'pizza_event.dart';

part 'pizza_state.dart';

class PizzaBloc extends Bloc<PizzaEvent, PizzaState> {
  final Box<Pizza> pizzaBox;
  final Box<PizzaInBasket> basketBox;

  PizzaBloc(this.pizzaBox, this.basketBox)
      : super(const PizzaInitial(pizzas: [])) {
    on<OpenPizzaCatalog>(onOpenPizzaCatalog);
    on<AddPizzaToCatalog>(onAddPizzaToCatalog);
    on<SaveCatalog>(onSaveCatalog);

    on<AddBalance>(onAddBalance);
    on<TurnDownBalance>(onTurnDownBalance);
    on<NameChanged>(onNameChanged);
    on<PriceChanged>(onPriceChanged);
    on<AssertChanged>(onAssertChanged);

    on<OpenPrise>(onOpenPrise);
    on<AddPizzaToBasket>(onAddPizzaToBasket);

    on<OpenBasket>(onOpenBasket);
    on<OrderBasket>(onOrderBasket);
    on<EditNumberBasket>(onEditNumberBasket);

    add(OpenPrise());
  }

  @override
  Future<void> close() {
    pizzaBox.close();
    basketBox.close();
    return super.close();
  }

  onOpenPizzaCatalog(OpenPizzaCatalog event, Emitter<PizzaState> emit) {
    emit(PizzaCatalogState(pizzas: pizzaBox.values.toList()));
  }

  onAddPizzaToCatalog(AddPizzaToCatalog event, Emitter<PizzaState> emit) {
    emit(PizzaCatalogState(pizzas: [
      Pizza(name: "", price: 0, balance: 0),
      ...(state.pizzas.isEmpty ? pizzaBox.values : state.pizzas)
    ]));
  }

  onAddBalance(AddBalance event, Emitter<PizzaState> emit) async {
    Pizza oldPizza = state.pizzas[event.pizza];
    Pizza newPizza = oldPizza.copy(balance: oldPizza.balance + 1);

    emit(PizzaCatalogState(
        pizzas: List.generate(state.pizzas.length,
                (index) => index != event.pizza ? state.pizzas[index] : newPizza)));
  }

  onTurnDownBalance(TurnDownBalance event, Emitter<PizzaState> emit) {
    Pizza oldPizza = state.pizzas[event.pizza];
    Pizza newPizza = oldPizza.copy(balance: oldPizza.balance - 1);

    emit(PizzaCatalogState(
        pizzas: List.generate(state.pizzas.length,
            (index) => index != event.pizza ? state.pizzas[index] : newPizza)));
  }

  onNameChanged(NameChanged event, Emitter<PizzaState> emit) {
    Pizza oldPizza = state.pizzas[event.pizza];
    Pizza newPizza = oldPizza.copy(name: event.newName);

    emit(PizzaCatalogState(
        pizzas: List.generate(state.pizzas.length,
            (index) => index != event.pizza ? state.pizzas[index] : newPizza)));
  }

  onPriceChanged(PriceChanged event, Emitter<PizzaState> emit) {
    Pizza oldPizza = state.pizzas[event.pizza];
    Pizza newPizza = oldPizza.copy(price: event.newPrice);

    emit(PizzaCatalogState(
        pizzas: List.generate(state.pizzas.length,
            (index) => index != event.pizza ? state.pizzas[index] : newPizza)));
  }

  onAssertChanged(AssertChanged event, Emitter<PizzaState> emit) {
    Pizza oldPizza = state.pizzas[event.pizza];
    Pizza newPizza = oldPizza.copy(asset: event.newAssert);

    emit(PizzaCatalogState(
        pizzas: List.generate(state.pizzas.length,
                (index) => index != event.pizza ? state.pizzas[index] : newPizza)));
  }

  onSaveCatalog(SaveCatalog event, Emitter<PizzaState> emit) {
    for (Pizza pizza in state.pizzas) {
      pizza.save(pizzaBox);
    }
    emit(PizzaCatalogState(pizzas: pizzaBox.values.toList()));
  }

  onOpenPrise(OpenPrise event, Emitter<PizzaState> emit) {
    List<Pizza> pizzas = pizzaBox.values.where((element) {
      if (element.balance > 0) {
        if (basketBox.values.map((e) => e.pizza).contains(element)) {
          return false;
        } else {
          return true;
        }
      } else {
        return false;
      }
    }).toList(growable: false);
    emit(PizzaInitial(pizzas: pizzas));
  }

  onAddPizzaToBasket(AddPizzaToBasket event, Emitter<PizzaState> emit) {
    PizzaInBasket(pizza: state.pizzas[event.pizza]).save(basketBox);

    List<Pizza> pizzas = pizzaBox.values.where((element) {
      if (element.balance > 0) {
        if (basketBox.values.map((e) => e.pizza).contains(element)) {
          return false;
        } else {
          return true;
        }
      } else {
        return false;
      }
    }).toList(growable: false);
    emit(PizzaInitial(pizzas: pizzas));
  }

  onOpenBasket(OpenBasket event, Emitter<PizzaState> emit) {
    List<PizzaInBasket> pizzasBasket = basketBox.values.toList();
    int total = 0;
    for (PizzaInBasket element in pizzasBasket) {
      total = total + (element.number*element.pizza.price);
    }
    emit(PizzaBasketInitial(pizzas: const [],pizzasBasket: pizzasBasket, total: total));
  }
  onOrderBasket(OrderBasket event, Emitter<PizzaState> emit) async {
    await basketBox.clear();

    List<PizzaInBasket> pizzasBasket = basketBox.values.toList();
    int total = 0;
    for (PizzaInBasket element in pizzasBasket) {
      total = total + (element.number*element.pizza.price);
    }
    emit(PizzaBasketInitial(pizzas: const [],pizzasBasket: pizzasBasket, total: total));
  }
  onEditNumberBasket(EditNumberBasket event, Emitter<PizzaState> emit) async {
    PizzaInBasket oldPizzaInBasket = state.pizzasBasket![event.pizza];
    PizzaInBasket newPizzaInBasket = oldPizzaInBasket.copy(number: event.number);

    await newPizzaInBasket.save(basketBox);

    List<PizzaInBasket> pizzasBasket = basketBox.values.toList();
    int total = 0;
    for (PizzaInBasket element in pizzasBasket) {
      total = total + (element.number*element.pizza.price);
    }
    emit(PizzaBasketInitial(pizzas: const [],pizzasBasket: pizzasBasket, total: total));
  }
}
