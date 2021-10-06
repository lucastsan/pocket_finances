import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pocket_finances/components/hero_dialog_route.dart';
import 'package:pocket_finances/components/main_card.dart';
import 'package:pocket_finances/components/shared_preferences_actions.dart';
import 'package:pocket_finances/constants.dart';
import 'package:pocket_finances/screens/incomes_change_popup.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

late double balance;
late double incomes;
late double fixedExpenses;
late double expenses;

class _HomePageState extends State<HomePage> {
  initState() {
    super.initState();
    checkPreferences().whenComplete(() {
      initValues();
      setState(() {});
    });
  }

  Future<void> initValues() async {
    incomes = await getIncomes() ?? 0;
    expenses = await getExpenses() ?? 0;
    fixedExpenses = await getFixedExpenses() ?? 0;
    balance = incomes - (expenses + fixedExpenses);
    print('Incomes: $incomes');
    print('Expenses: $expenses');
    print('Fixed Expenses: $fixedExpenses');
    print('Balance: $balance');
  }

  String incomesTag = 'change-incomes-value';
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 20.0,
            ),
            MainCard(
              cardChild: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Saldo Atual',
                          style: kBalanceTitleStyle,
                        ),
                        FutureBuilder(
                          future: initValues(),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Text(
                                'R\$ ' + balance.toStringAsFixed(2),
                                style: kBalanceTitleStyle,
                              );
                            } else
                              return Text('');
                          },
                        )
                      ],
                    ),
                    SizedBox(height: 15.0),
                    LinearPercentIndicator(
                      lineHeight: 10.0,
                    ),
                  ],
                ),
              ),
              backgroundColor: kMainCard,
            ),
            GestureDetector(
              onTap: () async {
                final result = await Navigator.of(context)
                    .push(HeroDialogRoute(builder: (context) {
                  return IncomesChangePopup(
                    heroTag: incomesTag,
                  );
                }));
                if (result) {
                  setState(() {
                    initValues();
                  });
                }
              },
              child: MainCard(
                cardChild: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Material(
                    type: MaterialType.transparency,
                    child: Column(
                      children: [
                        Text(
                          'Renda',
                          style: kCardTitleStyle,
                        ),
                        Hero(
                          tag: incomesTag,
                          child: Container(),
                        ),
                        FutureBuilder(
                          future: initValues(),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Text(
                                'R\$ ' + incomes.toStringAsFixed(2),
                                style: kValuesStyle,
                              );
                            } else
                              return Text('');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                backgroundColor: kMainCard,
              ),
            ),
            MainCard(
              cardChild: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Text(
                      'Despesas Fixas',
                      style: kCardTitleStyle,
                    ),
                    FutureBuilder(
                      future: initValues(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Text(
                            'R\$ ' + fixedExpenses.toStringAsFixed(2),
                            style: kValuesStyle,
                          );
                        } else
                          return Text('');
                      },
                    ),
                  ],
                ),
              ),
              backgroundColor: kMainCard,
            ),
            MainCard(
              cardChild: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Text(
                      'Despesas do Mês',
                      style: kCardTitleStyle,
                    ),
                    FutureBuilder(
                      future: initValues(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Text(
                            'R\$ ' + expenses.toStringAsFixed(2),
                            style: kValuesStyle,
                          );
                        } else
                          return Text('');
                      },
                    )
                  ],
                ),
              ),
              backgroundColor: kMainCard,
            )
          ],
        ),
      ),
    );
  }
}
