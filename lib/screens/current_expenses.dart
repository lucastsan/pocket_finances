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
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 60,
                              child: Center(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Color(0xFF2F3552),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_selectedItems.length ==
                                        expensesList.length) {
                                      setState(() {
                                        _selectedItems.clear();
                                        boxHeight = 0;
                                      });
                                    } else {
                                      for (var i = 0;
                                          i < expensesList.length;
                                          i++) {
                                        if (!_selectedItems.contains(i)) {
                                          setState(() {
                                            _selectedItems.insert(i, i);
                                          });
                                          print(_selectedItems);
                                        }
                                      }
                                    }
                                  },
                                  child: Icon(Icons.select_all),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _selectedItems.length <= 1
                                    ? _selectedItems.length.toString() +
                                        ' Item selecionado'
                                    : _selectedItems.length.toString() +
                                        ' Items selecionados',
                                style: kActivatedText,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                kSelectionColor),
                          ),
                          onPressed: () {
                            if (expensesList.length == _selectedItems.length) {
                              expensesList.clear();
                            } else {
                              for (var item in _selectedItems) {
                                if (expensesList.length - 1 < item) {
                                  item--;
                                }
                                expensesList.removeAt(item);
                              }
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
                if (result != false && result != null) {
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
