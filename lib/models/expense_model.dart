class Expense {
  Expense({
    required this.name,
    required this.value,
    required this.date,
  });
  late final String name;
  late final int value;
  late final String date;

  Expense.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['value'] = value;
    _data['date'] = date;
    return _data;
  }
}
