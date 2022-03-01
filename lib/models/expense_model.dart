import 'dart:convert';

class Expense {
  Expense({
    required this.name,
    required this.value,
    required this.date,
  });
  late final String name;
  late final double value;
  late final String date;

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      name: json['name'],
      value: json['value'],
      date: json['date'],
    );
  }

  @override
  String toString() {
    return '{${this.name}, ${this.value}, ${this.date}}';
  }

  static Map<String, dynamic> toJson(Expense expense) => {
        'name': expense.name,
        'value': expense.value,
        'date': expense.date,
      };

  static String encode(List<Expense> expenses) => json.encode(
        expenses
            .map<Map<String, dynamic>>((expense) => Expense.toJson(expense))
            .toList(),
      );

  static List<Expense> decode(String expenses) {
    var expensesListJson = jsonDecode(expenses) as List;
    List<Expense> expensesList = expensesListJson
        .map((expenseJson) => Expense.fromJson(expenseJson))
        .toList();
    return expensesList;
  }
}
