import 'package:flutter/material.dart';
import 'package:pocket_finances/components/main_card.dart';
import 'package:pocket_finances/constants.dart';
import 'package:pocket_finances/models/expense_model.dart';

class AddCurrentExpenses extends StatelessWidget {
  AddCurrentExpenses({Key? key, required this.heroTag}) : super(key: key);

  final String heroTag;
  final _expenseNameController = TextEditingController();
  final _expenseValueController = TextEditingController();
  final _expenseDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        flightShuttleBuilder: (BuildContext flightContext,
            Animation<double> animation,
            HeroFlightDirection flightDirection,
            BuildContext fromHeroContext,
            BuildContext toHeroContext) {
          final Hero hero = (flightDirection == HeroFlightDirection.pop
              ? fromHeroContext.widget
              : toHeroContext.widget) as Hero;
          return FadeTransition(
            opacity: animation.drive(
              Tween<double>(begin: 0.0, end: 1.0).chain(
                CurveTween(
                  curve: Interval(0.0, 1.0),
                ),
              ),
            ),
            child: hero.child,
          );
        },
        tag: heroTag,
        child: Material(
          type: MaterialType.transparency,
          child: MainCard(
            backgroundColor: kbackgroundColor,
            cardChild: Container(
              width: 300,
              height: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Adicionar Despesa',
                        style: kBalanceValueStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ExpTextField(
                        controller: _expenseNameController,
                        hintText: 'Descrição',
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ExpTextField(
                        controller: _expenseValueController,
                        hintText: 'Valor',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ExpTextField(
                        controller: _expenseDateController,
                        hintText: 'Data',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: MaterialButton(
                            highlightColor: kHighlightColor,
                            height: double.infinity,
                            child: Text('Cancelar', style: kValuesStyle),
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                          ),
                        ),
                        Container(
                          width: 1,
                          height: double.infinity,
                          color: Colors.grey,
                        ),
                        Expanded(
                          child: MaterialButton(
                            highlightColor: kHighlightColor,
                            height: double.infinity,
                            child: Text(
                              'Adicionar',
                              style: kValuesStyle,
                            ),
                            onPressed: () {
                              Expense newExpense = Expense(
                                  name: _expenseNameController.text,
                                  date: _expenseDateController.text,
                                  value: double.parse(
                                      _expenseValueController.text));
                              Navigator.pop(context, newExpense);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ExpTextField extends StatelessWidget {
  const ExpTextField(
      {Key? key,
      required this.controller,
      required this.hintText,
      this.keyboardType})
      : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: kDeactivateText,
        border: OutlineInputBorder(),
      ),
      keyboardType: keyboardType ?? TextInputType.text,
    );
  }
}
