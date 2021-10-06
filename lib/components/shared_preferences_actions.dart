import 'package:shared_preferences/shared_preferences.dart';

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

Future<double?> getBalance({required double balance}) async {
  return balance;
}

Future<double?> getIncomes() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getDouble('incomes');
}

Future<double?> getExpenses() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getDouble('expenses');
}

Future<double?> getFixedExpenses() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getDouble('fixedExpenses');
}

void setIncomes({required double incomes}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setDouble('incomes', incomes);
}
