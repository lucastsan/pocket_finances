import 'package:flutter/material.dart';
import 'package:pocket_finances/screens/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
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
  String heroTag = 'add-current-expense';
  List<Expense> expensesList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: buildListView(),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: heroTag,
        onPressed: () {
          Navigator.of(context).push(HeroDialogRoute(builder: (context) {
            return AddCurrentExpenses(heroTag: heroTag);
          }));
        },
        child: Material(
          type: MaterialType.transparency,
          child: Icon(
            Icons.add,
            size: 30.0,
          ),
        ),
      ),
    );
  }

  Widget emptyList() => Center(
        child: Text(
          'Sem Despesas',
          style: kBalanceTitleStyle,
        ),
      );
  Widget buildListView() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(expensesList[index].name),
        );
      },
      itemCount: expensesList.length,
    );
  }

  void addExpense(Expense expense) {
    expensesList.insert(0, expense);
    saveExpensesList();
  }

  void saveExpensesList() async {
    List<String> expensesStringList =
        expensesList.map((item) => json.encode(item.toJson())).toList();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('expenses-list', expensesStringList);
  }

  void getExpensesList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? expensesStringList = prefs.getStringList('expenses-list');
    Iterable list = json.decode(expensesStringList.toString());
    expensesList = list.map((item) => Expense.fromJson(item)).toList();
  }
}
