import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgmk_test_task/business/pizza_bloc.dart';
import 'package:sgmk_test_task/model/pizza.dart';
import 'package:sgmk_test_task/ui/add_pizza_page.dart';
import 'package:sgmk_test_task/ui/basket_page.dart';
import 'package:sgmk_test_task/ui/widgets/app_bar_widget.dart';
import 'package:sgmk_test_task/ui/widgets/background_widget.dart';
import 'package:sgmk_test_task/ui/widgets/text_styles.dart';

class Home extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute(builder: (context) {
      BlocProvider.of<PizzaBloc>(context).add(OpenPrise());
      return const Home();
    });
  }
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      scaffold: Scaffold(
        appBar: CustomAppBar.nonBack(title: "Pizza Market", actions: [
          InkWell(
              borderRadius: BorderRadius.circular(16.0),
              child:
                  Image.asset("assets/icons/user.png", width: 24, height: 24),
              onTap: () => Navigator.of(context).pushReplacement(AddPizza.route())
          ),
          InkWell(
              borderRadius: BorderRadius.circular(16.0),
              child:
                  Image.asset("assets/icons/basket.png", width: 24, height: 24),
              onTap: () => Navigator.of(context).pushReplacement(Basket.route())
          ),
        ]),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 108.5, 24.0, 64.5),
          child: Column(
            children: const [_Body()],
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
        return current.runtimeType == PizzaInitial &&
            previous.pizzas.length != current.pizzas.length;
      },
      builder: (context, state) {
        List<Pizza> pizas = state.pizzas;
        return ListView.builder(
          itemCount: pizas.length,
          itemBuilder: (context, index) {
            return _PizzaCard(index);
          },
        );
      },
    ));
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
            return current.runtimeType == PizzaInitial &&
                current.pizzas.length > pizzaIndex &&
                previous.pizzas[pizzaIndex] != current.pizzas[pizzaIndex];
          },
          builder: (context, state) {
            Pizza pizza = state.pizzas[pizzaIndex];
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: InkWell(
                onTap: () => BlocProvider.of<PizzaBloc>(context)
                    .add(AddPizzaToBasket(pizzaIndex)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Image.asset(pizza.asset),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(pizza.name, style: TextStyles.pizzaName)
                      ],
                    ),
                    Text("\$${pizza.price}", style: TextStyles.bigPrice)
                  ],
                ),
              ),
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
