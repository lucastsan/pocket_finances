import 'package:flutter/material.dart';
import 'package:pocket_finances/components/shared_preferences_actions.dart';
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
  final String heroTag = 'add-current-expense';
  late List<Expense> expensesList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: getExpensesList(),
          initialData: expensesList,
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
              return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(snapshot.data![index].name),
                      subtitle: Text(snapshot.data![index].date),
                      trailing: Text(snapshot.data![index].value.toString()),
                    );
                  });
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: heroTag,
        onPressed: () async {
          final result = await Navigator.of(context)
              .push(HeroDialogRoute(builder: (context) {
            return AddCurrentExpenses(heroTag: heroTag);
          }));
          setState(() {
            addExpense(result, expensesList);
          });
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

  void addExpense(Expense expense, List<Expense> expensesList) {
    expensesList.add(expense);
    saveExpensesList(expensesList).whenComplete(() => print(expensesList));
  }
}
