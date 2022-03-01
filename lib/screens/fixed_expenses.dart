import 'package:flutter/material.dart';
import 'package:pocket_finances/components/hero_dialog_route.dart';
import 'package:pocket_finances/components/shared_preferences_actions.dart';
import 'package:pocket_finances/models/fixed_expense_model.dart';

import '../constants.dart';
import 'add_fixed_expenses.dart';
import 'main_page.dart';

class FixedExpensesPage extends StatefulWidget {
  const FixedExpensesPage({Key? key}) : super(key: key);

  @override
  _FixedExpensesPageState createState() => _FixedExpensesPageState();
}

class _FixedExpensesPageState extends State<FixedExpensesPage> {
  final String heroTag = 'add-fixed-expense';
  late List<FixedExpense> fixedExpensesList;
  double boxHeight = 0;
  List<int> _selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 10),
        child: FutureBuilder(
          future:
              getFixedExpensesList().then((value) => fixedExpensesList = value),
          initialData: fixedExpensesList = [],
          builder: (BuildContext context,
              AsyncSnapshot<List<FixedExpense>> snapshot) {
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return emptyList();
            } else {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            color: (_selectedItems.contains(index))
                                ? kHighlightColor
                                : Colors.transparent,
                            child: ListTile(
                              onLongPress: () {
                                if (!_selectedItems.contains(index)) {
                                  setState(() {
                                    boxHeight = 80;
                                    _selectedItems.add(index);
                                    print(_selectedItems);
                                  });
                                }
                              },
                              onTap: () {
                                if (_selectedItems.isNotEmpty) {
                                  if (_selectedItems.contains(index)) {
                                    if (_selectedItems.length <= 1) {
                                      boxHeight = 0;
                                    }
                                    setState(() {
                                      _selectedItems.removeWhere(
                                          (element) => element == index);
                                      print(_selectedItems);
                                    });
                                  } else {
                                    setState(() {
                                      _selectedItems.add(index);
                                      print(_selectedItems);
                                    });
                                  }
                                }
                              },
                              title: Text(
                                snapshot.data![index].name,
                                style: kBalanceTitleStyle,
                              ),
                              subtitle: Text(
                                snapshot.data![index].recurrenceDate,
                                style: kInfoValueStyle,
                              ),
                              trailing: Text(
                                snapshot.data![index].value.toString(),
                                style: kBalanceTitleStyle,
                              ),
                            ),
                          );
                        }),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    padding: EdgeInsets.all(15),
                    width: double.maxFinite,
                    height: boxHeight,
                    color: kMainCard,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedItems.length <= 1
                              ? _selectedItems.length.toString() +
                                  ' Item selecionado'
                              : _selectedItems.length.toString() +
                                  ' Items selecionados',
                          style: kActivatedText,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                kSelectionColor),
                          ),
                          onPressed: () {
                            for (var item in _selectedItems) {
                              if (fixedExpensesList.length - 1 < item) {
                                item--;
                              }
                              fixedExpensesList.removeAt(item);
                            }
                            setState(() {
                              _selectedItems.clear();
                              saveFixedExpensesList(fixedExpensesList);
                              boxHeight = 0;
                              expController.add(1);
                            });
                          },
                          child: Icon(Icons.delete),
                        )
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
      floatingActionButton: _selectedItems.length == 0
          ? FloatingActionButton(
              heroTag: heroTag,
              onPressed: () async {
                final result = await Navigator.of(context)
                    .push(HeroDialogRoute(builder: (context) {
                  return AddFixedExpenses(heroTag: heroTag);
                }));
                if (result != false && result != null) {
                  setState(() {
                    addFixedExpense(result, fixedExpensesList);
                    expController.add(1);
                  });
                }
              },
              child: Material(
                type: MaterialType.transparency,
                child: Icon(
                  Icons.add,
                  size: 30.0,
                ),
              ),
            )
          : null,
    );
  }

  Widget emptyList() => Center(
        child: Text(
          'Sem Despesas',
          style: kBalanceTitleStyle,
        ),
      );

  void addFixedExpense(
      FixedExpense fixedExpense, List<FixedExpense> fixedExpensesList) {
    fixedExpensesList.add(fixedExpense);
    saveFixedExpensesList(fixedExpensesList)
        .whenComplete(() => print(fixedExpensesList));
  }
}
