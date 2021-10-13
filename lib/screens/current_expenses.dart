import 'package:flutter/material.dart';
import 'package:pocket_finances/components/hero_dialog_route.dart';
import 'package:pocket_finances/screens/add_current_expenses.dart';

class CurrentExpensesPage extends StatefulWidget {
  const CurrentExpensesPage({Key? key}) : super(key: key);

  @override
  _CurrentExpensesPageState createState() => _CurrentExpensesPageState();
}

class _CurrentExpensesPageState extends State<CurrentExpensesPage> {
  String heroTag = 'add-current-expense';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(),
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
}
