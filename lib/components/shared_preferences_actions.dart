import 'package:pocket_finances/models/fixed_expense_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pocket_finances/models/expense_model.dart';

Future<void> checkPreferences() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getDouble('incomes');
  } catch (err) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('incomes', 0);
    prefs.setDouble('expenses', 0);
    prefs.setDouble('fixedExpenses', 0);
  }
}

Future<void> checkExpensesList() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('expenses-list');
  } catch (err) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('expenses-list', '[]');
  }
}

Future<double?> getBalance({required double balance}) async {
  return balance;
}

Future<double?> getIncomes() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getDouble('incomes');
}

Future<double?> getExpenses() async {
  List<Expense> expensesList = await getExpensesList();
  double expensesSum = 0;
  for (var i = 0; i < expensesList.length; i++) {
    expensesSum += expensesList[i].value;
  }
  return expensesSum;
}

Future<double?> getFixedExpenses() async {
  List<FixedExpense> expensesList = await getFixedExpensesList();
  double expensesSum = 0;
  for (var i = 0; i < expensesList.length; i++) {
    expensesSum += expensesList[i].value;
  }
  return expensesSum;
}

void setIncomes({required double incomes}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setDouble('incomes', incomes);
}

Future<void> saveExpensesList(List<Expense> expenses) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String encodedData = Expense.encode(expenses);
  await prefs.setString('expenses-list', encodedData);
}

Future<void> saveFixedExpensesList(List<FixedExpense> expenses) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String encodedData = FixedExpense.encode(expenses);
  await prefs.setString('fixedExpenses-list', encodedData);
}

Future<List<Expense>> getExpensesList() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var expensesString = prefs.getString('expenses-list');
  if (expensesString?.isEmpty ?? true) {
    return <Expense>[];
  } else {
    final List<Expense> expensesData = Expense.decode(expensesString!);
    return expensesData;
  }
}

Future<List<FixedExpense>> getFixedExpensesList() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var expensesString = prefs.getString('fixedExpenses-list');
  if (expensesString?.isEmpty ?? true) {
    return <FixedExpense>[];
  } else {
    final List<FixedExpense> expensesData =
        FixedExpense.decode(expensesString!);
    return expensesData;
  }
}
