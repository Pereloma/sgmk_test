import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sgmk_test_task/business/pizza_bloc.dart';
import 'package:sgmk_test_task/model/pizza_in_basket.dart';
import 'package:sgmk_test_task/ui/add_pizza_page.dart';
import 'package:sgmk_test_task/ui/home_page.dart';

import 'model/pizza.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PizzaAdapter());
  Hive.registerAdapter(PizzaInBasketAdapter());
  Box<Pizza> pizzaBox = await Hive.openBox("pizzaBox");
  Box<PizzaInBasket> basketBox = await Hive.openBox("basketBox");


  runApp(MyApp(pizzaBox: pizzaBox,basketBox: basketBox));
}

class MyApp extends StatelessWidget {
  final Box<Pizza> pizzaBox;
  final Box<PizzaInBasket> basketBox;
  const MyApp({Key? key, required this.pizzaBox, required this.basketBox}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (_) => PizzaBloc(pizzaBox,basketBox),
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0x00000000),
        ),
        home: const Home(),
      ),
    );
  }
}