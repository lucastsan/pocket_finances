import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocket_finances/components/main_card.dart';
import 'package:pocket_finances/components/shared_preferences_actions.dart';
import 'package:pocket_finances/constants.dart';

class IncomesChangePopup extends StatelessWidget {
  IncomesChangePopup(
      {Key? key, required this.heroTag, required this.incomesValue})
      : super(key: key);

  final String heroTag;
  final _incomesInputController = TextEditingController();
  final double incomesValue;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Hero(
          tag: heroTag,
          child: Material(
              type: MaterialType.transparency,
              child: MainCard(
                backgroundColor: kbackgroundColor,
                cardChild: Container(
                  height: 180.0,
                  width: 300.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Alterar Renda',
                            style: kBalanceValueStyle,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            controller: _incomesInputController,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Insira sua renda',
                              hintStyle: kDeactivateText,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r"[0-9.]")),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 3,
                              child: MaterialButton(
                                highlightColor: kHighlightColor,
                                height: double.infinity,
                                child: Text('Cancelar', style: kValuesStyle),
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                              ),
                            ),
                            Container(
                              width: 1,
                              height: double.infinity,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              color: Colors.grey,
                            ),
                            Expanded(
                              flex: 3,
                              child: MaterialButton(
                                highlightColor: kHighlightColor,
                                height: double.infinity,
                                child: Text(
                                  'Atualizar',
                                  style: kValuesStyle,
                                ),
                                onPressed: () {
                                  setIncomes(
                                      incomes: _incomesInputController
                                              .text.isNotEmpty
                                          ? double.parse(
                                              _incomesInputController.text)
                                          : 0);
                                  Navigator.pop(context, true);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
