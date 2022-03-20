import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgmk_test_task/business/pizza_bloc.dart';
import 'package:sgmk_test_task/model/pizza_in_basket.dart';
import 'package:sgmk_test_task/ui/widgets/add_delete_button_widget.dart';
import 'package:sgmk_test_task/ui/widgets/app_bar_widget.dart';
import 'package:sgmk_test_task/ui/widgets/background_widget.dart';
import 'package:sgmk_test_task/ui/widgets/text_styles.dart';

class Basket extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute(builder: (context) {
      BlocProvider.of<PizzaBloc>(context).add(OpenBasket());
      return const Basket();
    });
  }

  const Basket({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      scaffold: Scaffold(
        appBar: const CustomAppBar(title: "Order details"),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 24.0),
          child: Column(
            children: const [_Body(), _Footer()],
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<PizzaBloc, PizzaState>(
        buildWhen: (previous, current) {
          return current.runtimeType == PizzaBasketInitial &&
              previous.pizzasBasket?.length != current.pizzasBasket?.length;
        },
        builder: (context, state) {
          List<PizzaInBasket> pizzasBasket = state.pizzasBasket ?? [];
          return ListView.builder(
            itemCount: pizzasBasket.length,
            itemBuilder: (context, index) => _PizzaCard(index),
          );
        },
      ),
    );
  }
}

class _PizzaCard extends StatelessWidget {
  final int pizzaIndex;

  const _PizzaCard(this.pizzaIndex, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12.0, 12.0, 32.0, 12.0),
        child: BlocBuilder<PizzaBloc, PizzaState>(
          buildWhen: (previous, current) {
            return current.runtimeType == PizzaBasketInitial &&
                current.pizzasBasket!.length > pizzaIndex &&
                previous.pizzasBasket![pizzaIndex].number !=
                    current.pizzasBasket![pizzaIndex].number;
          },
          builder: (context, state) {
            PizzaInBasket pizzaInBasket = state.pizzasBasket![pizzaIndex];
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Image.asset(pizzaInBasket.pizza.asset),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 27,
                          child: Center(
                            child: Text(
                              pizzaInBasket.pizza.name,
                              style: TextStyles.pizzaName,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 27,
                          child: Center(
                              child: Text(
                                  "\$${pizzaInBasket.pizza.price * pizzaInBasket.number}",
                                  style: TextStyles.smallPrice)),
                        )
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    AddDeleteButton.delete(
                        active: pizzaInBasket.number > 1,
                        onTap: () => BlocProvider.of<PizzaBloc>(context).add(
                            EditNumberBasket(pizzaIndex,
                                number: pizzaInBasket.number - 1))),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                      child: Text("${pizzaInBasket.number}",
                          style: TextStyles.amount),
                    ),
                    AddDeleteButton.add(
                        active:
                            pizzaInBasket.number < pizzaInBasket.pizza.balance,
                        onTap: () => BlocProvider.of<PizzaBloc>(context).add(
                            EditNumberBasket(pizzaIndex,
                                number: pizzaInBasket.number + 1))),
                  ],
                )
              ],
            );
          },
        ),
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  color: Color(0x145A6CEA),
                  blurRadius: 50.0,
                  offset: Offset(12, 26))
            ],
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      height: 149,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 1,
            color: const Color(0xFFFFFFFF),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total", style: TextStyles.whiteText),
              BlocBuilder<PizzaBloc, PizzaState>(
                builder: (context, state) {
                  if (state.runtimeType == PizzaBasketInitial) {
                    return Text("\$${(state as PizzaBasketInitial).total}",
                        style: TextStyles.whitePrice);
                  } else {
                    return const Text("\$99", style: TextStyles.whitePrice);
                  }
                },
              ),
            ],
          ),
          Container(
            height: 55,
            child: InkWell(
              onTap: () => BlocProvider.of<PizzaBloc>(context).add(OrderBasket()),
              child: const Center(
                  child: Text(
                "Place my order",
                style: TextStyles.pinkButton,
              )),
            ),
            decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(32.0)),
          ),
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
              begin: FractionalOffset(0.0012, 0.5),
              end: FractionalOffset(0.9988, 0.5),
              transform: GradientRotation(3.92699),
              colors: [Color(0xFFFF1843), Color(0xFFFF7E95)])),
    );
  }
}
