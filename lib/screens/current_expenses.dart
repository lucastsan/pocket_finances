import 'package:flutter/material.dart';
import 'package:pocket_finances/components/shared_preferences_actions.dart';
import 'package:pocket_finances/screens/main_page.dart';
import 'package:pocket_finances/components/hero_dialog_route.dart';
import 'package:pocket_finances/constants.dart';
import 'package:pocket_finances/models/expense_model.dart';
import 'package:pocket_finances/screens/add_current_expenses.dart';

class CurrentExpensesPage extends StatefulWidget {
  const CurrentExpensesPage({Key? key}) : super(key: key);

  @override
  _CurrentExpensesPageState createState() => _CurrentExpensesPageState();
}

class _CurrentExpensesPageState extends State<CurrentExpensesPage> {
  final String heroTag = 'add-current-expense';
  late List<Expense> expensesList;
  double boxHeight = 0;
  List<int> _selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 10),
        child: FutureBuilder(
          future: getExpensesList().then((value) => expensesList = value),
          initialData: expensesList = [],
          builder:
              (BuildContext context, AsyncSnapshot<List<Expense>> snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: Text(
                  'Carregando...',
                  style: kBalanceTitleStyle,
                ),
              );
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
                                snapshot.data![index].date,
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
                        Text(_selectedItems.length.toString() +
                            ' Items selecionados'),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                kSelectionColor),
                          ),
                          onPressed: () {
                            for (var item in _selectedItems) {
                              if (expensesList.length - 1 < item) {
                                item--;
                              }
                              expensesList.removeAt(item);
                            }
                            setState(() {
                              _selectedItems.clear();
                              saveExpensesList(expensesList);
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
                  return AddCurrentExpenses(heroTag: heroTag);
                }));
                if (result != false) {
                  setState(() {
                    addExpense(result, expensesList);
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

  void addExpense(Expense expense, List<Expense> expensesList) {
    expensesList.add(expense);
    saveExpensesList(expensesList).whenComplete(() => print(expensesList));
  }
}
