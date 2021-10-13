import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pocket_finances/constants.dart';

TabBar buildTabBar() {
  return TabBar(
    tabs: <Widget>[
      TabBarBox(
        labelText: 'Página Principal',
      ),
      TabBarBox(
        labelText: 'Despesas',
      ),
      TabBarBox(
        labelText: 'Despesas Fixas',
      ),
    ],
    indicatorSize: TabBarIndicatorSize.label,
    indicator: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      color: kSelectionColor,
    ),
    labelPadding: EdgeInsets.all(5.0),
    unselectedLabelColor: kDeactivateText.color,
  );
}

class TabBarBox extends StatelessWidget {
  const TabBarBox({Key? key, required this.labelText}) : super(key: key);

  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Text(
        labelText,
        textAlign: TextAlign.center,
        style: GoogleFonts.nunito(
          fontSize: 15.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
