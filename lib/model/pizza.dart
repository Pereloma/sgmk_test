import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'pizza.g.dart';

@HiveType(typeId: 1)
class Pizza {
  @HiveField(0)
  dynamic? _key;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final int price;
  @HiveField(3)
  final int balance;
  @HiveField(4)
  final String asset;

  Pizza({required this.name, required this.price, required this.balance, String? asset}):
  this.asset = asset??"assets/pizza/p1.png";

  Pizza._({required this.name, required this.price, required this.balance, required this.asset, required dynamic key})
  : _key = key;

  save(Box<Pizza> pizzaBox) async{
    if(pizzaBox.containsKey(_key)){
      pizzaBox.put(_key, this);
    }
    else{
      _key = await pizzaBox.add(this);
      pizzaBox.put(_key, this);
    }
  }

  Pizza copy({String? name, int? price, int? balance, String? asset}){
    return Pizza._(
        name: name??this.name,
        price: price??this.price,
        balance: balance??this.balance,
        asset: asset??this.asset,
        key: _key
    );
  }


  dynamic get key => _key;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pizza &&
          balance == other.balance &&
          name == other.name &&
          price == other.price &&
          asset == other.asset;

  @override
  int get hashCode =>
      name.hashCode ^ price.hashCode ^ balance.hashCode ^ asset.hashCode;
}