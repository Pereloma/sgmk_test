import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgmk_test_task/business/pizza_bloc.dart';
import 'package:sgmk_test_task/model/pizza.dart';
import 'package:sgmk_test_task/ui/widgets/add_delete_button_widget.dart';
import 'package:sgmk_test_task/ui/widgets/app_bar_widget.dart';
import 'package:sgmk_test_task/ui/widgets/background_widget.dart';
import 'package:sgmk_test_task/ui/widgets/select_assert.dart';
import 'package:sgmk_test_task/ui/widgets/text_styles.dart';

class AddPizza extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute(builder: (context) {
      BlocProvider.of<PizzaBloc>(context).add(OpenPizzaCatalog());
      return const AddPizza();
    });
  }

  const AddPizza({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      scaffold: Scaffold(
        appBar: CustomAppBar(title: "Add pizza", actions: [
          AddDeleteButton.add(
              active: true,
              onTap: () =>
                  BlocProvider.of<PizzaBloc>(context).add(AddPizzaToCatalog()))
        ]),
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
          return current.runtimeType == PizzaCatalogState &&
              previous.pizzas.length != current.pizzas.length;
        },
        builder: (context, state) {
          List<Pizza> pizzas = state.pizzas;
          return ListView.builder(
            itemCount: pizzas.length,
            itemBuilder: (context, index) =>
                _PizzaCard(index, key: Key("PizzaCard_${pizzas[index].name}")),
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
        height: 218.0,
        padding: const EdgeInsets.fromLTRB(12.0, 12.0, 32.0, 12.0),
        child: BlocBuilder<PizzaBloc, PizzaState>(
          buildWhen: (previous, current) {
            return current.runtimeType == PizzaCatalogState &&
                current.pizzas.length > pizzaIndex &&
                (previous.pizzas[pizzaIndex].balance !=
                    current.pizzas[pizzaIndex].balance ||
                    previous.pizzas[pizzaIndex].asset !=
                        current.pizzas[pizzaIndex].asset);
          },
          builder: (context, state) {
            Pizza pizza = state.pizzas[pizzaIndex];
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                            onTap: () async {
                              String asset = await showDialog(
                                  builder: (context) =>
                                      const SelectAssertDialog(),
                                  context: context);
                              BlocProvider.of<PizzaBloc>(context).add(
                                  AssertChanged(pizzaIndex, newAssert: asset));
                            },
                            child: Image.asset(pizza.asset)),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 27,
                              child: Text(
                                "Name",
                                style: TextStyles.pizzaName,
                              ),
                            ),
                            _InputText(
                                onChanged: (name) =>
                                    BlocProvider.of<PizzaBloc>(context).add(
                                        NameChanged(pizzaIndex, newName: name)),
                                text: pizza.name),
                            const SizedBox(
                              height: 20,
                            ),
                            const SizedBox(
                              height: 27,
                              child: Text(
                                "Price",
                                style: TextStyles.pizzaName,
                              ),
                            ),
                            _InputText(
                                onChanged: (price) =>
                                    BlocProvider.of<PizzaBloc>(context).add(
                                        PriceChanged(pizzaIndex,
                                            newPrice: price)),
                                inputType: TextInputType.number,
                                text: pizza.price.toString()),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(width: 20.0),
                    AddDeleteButton.delete(
                      active: pizza.balance > 0,
                      onTap: () => BlocProvider.of<PizzaBloc>(context)
                          .add(TurnDownBalance(pizzaIndex)),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                      child: Text("${pizza.balance}", style: TextStyles.amount),
                    ),
                    AddDeleteButton.add(
                      active: true,
                      onTap: () => BlocProvider.of<PizzaBloc>(context)
                          .add(AddBalance(pizzaIndex)),
                    ),
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

class _InputText extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final TextInputType? inputType;
  final TextEditingController textEditingController;

  _InputText(
      {Key? key, required this.onChanged, this.inputType, required String text})
      : textEditingController = TextEditingController(),
        super(key: key) {
    textEditingController.value = TextEditingValue(
        text: text,
        selection: TextSelection.fromPosition(
          TextPosition(offset: text.length),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: double.infinity,
      decoration:
          BoxDecoration(border: Border.all(color: const Color(0xFFC7CAD1))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 8.0, 0.0, 8.0),
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                scrollPadding: const EdgeInsets.all(0),
                keyboardType: inputType,
                controller: textEditingController,
                onChanged: onChanged,
                style: TextStyles.input,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 9.0, 13.0, 9.0),
            child: Image.asset("assets/icons/path.png"),
          )
        ],
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
      height: 75,
      child: InkWell(
        onTap: () => BlocProvider.of<PizzaBloc>(context).add(SaveCatalog()),
        child: const Center(
          child: Text(
            "Save",
            style: TextStyles.whiteButton,
          ),
        ),
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
