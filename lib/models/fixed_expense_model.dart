class FixedExpense {
  FixedExpense({
    required this.name,
    required this.value,
    required this.recurrenceDate,
  });
  late final String name;
  late final int value;
  late final String recurrenceDate;

  FixedExpense.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
    recurrenceDate = json['recurrenceDate'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['value'] = value;
    _data['recurrenceDate'] = recurrenceDate;
    return _data;
  }
}
