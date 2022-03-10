import 'package:flutter/material.dart';
import 'package:pocket_finances/components/main_card.dart';
import 'package:pocket_finances/constants.dart';
import 'package:pocket_finances/models/expense_model.dart';
import 'package:pocket_finances/models/textfield.dart';
import 'package:flutter/services.dart';

class EditCurrentExpenses extends StatefulWidget {
  EditCurrentExpenses(
      {Key? key,
      required this.heroTag,
      required this.expenseName,
      required this.expenseValue,
      required this.expenseDate})
      : super(key: key);

  final String heroTag;
  final String expenseName;
  final double expenseValue;
  final String expenseDate;

  @override
  _EditCurrentExpensesState createState() => _EditCurrentExpensesState();
}

class _EditCurrentExpensesState extends State<EditCurrentExpenses> {
  late final TextEditingController _expenseNameController;
  late final TextEditingController _expenseValueController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _expenseNameController = TextEditingController(text: widget.expenseName);
    _expenseValueController =
        TextEditingController(text: widget.expenseValue.toString());
    _selectedDate = toDateTime(widget.expenseDate);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: formKey,
        child: Hero(
          flightShuttleBuilder: (BuildContext flightContext,
              Animation<double> animation,
              HeroFlightDirection flightDirection,
              BuildContext fromHeroContext,
              BuildContext toHeroContext) {
            final Hero hero = (flightDirection == HeroFlightDirection.pop
                ? fromHeroContext.widget
                : toHeroContext.widget) as Hero;
            return FadeTransition(
              opacity: animation.drive(
                Tween<double>(begin: 0.0, end: 1.0).chain(
                  CurveTween(
                    curve: Interval(0.0, 1.0),
                  ),
                ),
              ),
              child: hero.child,
            );
          },
          tag: widget.heroTag,
          child: Material(
            type: MaterialType.transparency,
            child: MainCard(
              backgroundColor: kbackgroundColor,
              cardChild: Container(
                width: 300,
                height: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'Editar Despesa',
                          style: kBalanceValueStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ExpTextField(
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'O campo deve ser preenchido';
                            }
                          },
                          controller: _expenseNameController,
                          hintText: 'Descrição',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ExpTextField(
                          validator: (text) {
                            if (text!.isEmpty) {
                              return 'O campo deve ser preenchido';
                            } else {}
                          },
                          controller: _expenseValueController,
                          hintText: 'Valor',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r"[0-9.]")),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  alignment: Alignment.centerLeft,
                                  height: double.infinity,
                                  child: Text(
                                    _selectedDate == null
                                        ? widget.expenseDate
                                        : getDate(),
                                    style: kInputText,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black26),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: double.infinity,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              kSelectionColor),
                                    ),
                                    onPressed: () {
                                      selectDate(context);
                                    },
                                    child: Icon(Icons.calendar_today_outlined),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: MaterialButton(
                              highlightColor: kHighlightColor,
                              height: double.infinity,
                              child: Text('Cancelar', style: kValuesStyle),
                              onPressed: () async {
                                Navigator.pop(context, false);
                              },
                            ),
                          ),
                          Container(
                            width: 1,
                            height: double.infinity,
                            color: Colors.grey,
                          ),
                          Expanded(
                            child: MaterialButton(
                              highlightColor: kHighlightColor,
                              height: double.infinity,
                              child: Text(
                                'Atualizar',
                                style: kValuesStyle,
                              ),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  Expense updatedExpense = Expense(
                                      name: _expenseNameController.text,
                                      date: getDate(),
                                      value: double.parse(
                                          _expenseValueController.text));
                                  Navigator.pop(context, updatedExpense);
                                } else {
                                  formKey.currentState!.validate();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future selectDate(BuildContext context) async {
    final initialDate = _selectedDate;
    DateTime? datePicked = await showDatePicker(
        context: context,
        initialDate: initialDate!,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5),
        builder: (BuildContext context, Widget? child) {
          return Theme(data: ThemeData.dark(), child: child!);
        });

    if (datePicked == null) {
      datePicked = initialDate;
    }

    setState(() {
      _selectedDate = datePicked == null ? initialDate : datePicked;
    });
  }

  String getDate() {
    return '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';
  }

  DateTime toDateTime(String date) {
    int? year;
    int? month;
    int? day;
    if (date[1] == "/") {
      day = int.parse(date[0]);
      if (date[3] == "/") {
        month = int.parse(date[2]);
        year = int.parse(date[4] + date[5] + date[6] + date[7]);
      } else {
        month = int.parse(date[2] + date[3]);
        year = int.parse(date[5] + date[6] + date[7] + date[8]);
      }
    }
    if (date[2] == "/") {
      day = int.parse(date[0] + date[1]);
      if (date[4] == "/") {
        month = int.parse(date[3]);
        year = int.parse(date[5] + date[6] + date[7] + date[8]);
      } else {
        month = int.parse(date[3] + date[4]);
        year = int.parse(date[6] + date[7] + date[8] + date[9]);
      }
    }

    return DateTime(year!, month!, day!);
  }
}
