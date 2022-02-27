import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pocket_finances/components/hero_dialog_route.dart';
import 'package:pocket_finances/components/main_card.dart';
import 'package:pocket_finances/components/shared_preferences_actions.dart';
import 'package:pocket_finances/constants.dart';
import 'package:pocket_finances/screens/incomes_change_popup.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.expStream}) : super(key: key);

  final Stream<int> expStream;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double balance;
  late double incomes;
  late double fixedExpenses;
  late double expenses;
  late double percentage;

  Future<void> initValues() async {
    incomes = await getIncomes() ?? 0;
    expenses = await getExpenses() ?? 0;
    fixedExpenses = await getFixedExpenses() ?? 0;
    balance = incomes - (expenses + fixedExpenses);
    calcPercentage();
  }

  initState() {
    super.initState();
    checkPreferences().whenComplete(() {
      initValues().whenComplete(() {
        print('Incomes: $incomes');
        print('Expenses: $expenses');
        print('Fixed Expenses: $fixedExpenses');
        print('Balance: $balance');
      });
    });
    widget.expStream.listen((stream) {
      setState(() {
        updateExp();
      });
    });
  }

  void updateExp() async {
    initValues();
  }

  void calcPercentage() {
    var calc = (expenses + fixedExpenses) / incomes;
    if (calc >= 0 && calc <= 1) {
      percentage = calc;
    }
    if (calc < 0) {
      percentage = 0;
    }
    if (calc > 1) {
      percentage = 1;
    }
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
                    FutureBuilder(
                      future: initValues(),
                      builder:
                          (BuildContext context, AsyncSnapshot<void> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return LinearPercentIndicator(
                            lineHeight: 10.0,
                            percent: percentage,
                            progressColor: kSelectionColor,
                          );
                        } else {
                          return SizedBox(
                            height: 10,
                          );
                        }
                      },
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
                    incomesValue: incomes,
                  );
                }));
                if (result != null) {
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
                backgroundColor: kIncomesCard,
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
