import 'dart:convert';

class FixedExpense {
  FixedExpense({
    required this.name,
    required this.value,
    required this.recurrenceDate,
  });
  late final String name;
  late final double value;
  late final String recurrenceDate;

  factory FixedExpense.fromJson(Map<String, dynamic> json) {
    return FixedExpense(
      name: json['name'],
      value: json['value'],
      recurrenceDate: json['recurrenceDate'],
    );
  }

  static Map<String, dynamic> toJson(FixedExpense fixedExpense) => {
        'name': fixedExpense.name,
        'value': fixedExpense.value,
        'recurrenceDate': fixedExpense.recurrenceDate,
      };

  static String encode(List<FixedExpense> fixedExpenses) => json.encode(
        fixedExpenses
            .map<Map<String, dynamic>>(
                (fixedExpense) => FixedExpense.toJson(fixedExpense))
            .toList(),
      );

  static List<FixedExpense> decode(String fixedExpenses) {
    var fixedExpensesListJson = jsonDecode(fixedExpenses) as List;
    List<FixedExpense> expensesList = fixedExpensesListJson
        .map((fixedExpenseJson) => FixedExpense.fromJson(fixedExpenseJson))
        .toList();
    print(expensesList);
    return expensesList;
  }

  @override
  String toString() {
    return '{${this.name}, ${this.value}, ${this.recurrenceDate}}';
  }
}
