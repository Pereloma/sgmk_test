import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sgmk_test_task/model/pizza.dart';

part 'pizza_in_basket.g.dart';

@HiveType(typeId: 2)
class PizzaInBasket {
  @HiveField(0)
  dynamic _key;
  @HiveField(1)
  final Pizza pizza;
  @HiveField(2)
  final int number;

  PizzaInBasket({required this.pizza, int? number,}) : this.number = 1;

  PizzaInBasket._(
      {required this.pizza, required this.number, required dynamic key})
      : this._key = key;

  save(Box<PizzaInBasket> basketBox) async {
    if (basketBox.containsKey(_key)) {
      basketBox.put(_key, this);
    } else {
      _key = await basketBox.add(this);

    }
  }

  PizzaInBasket copy({Pizza? pizza, int? number}) {
    return PizzaInBasket._(
        pizza: pizza ?? this.pizza, number: number ?? this.number, key: _key);
  }

  dynamic get key => _key;
}
