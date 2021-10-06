import 'package:flutter/material.dart';
import 'package:pocket_finances/components/Tab_bar.dart';
import 'package:pocket_finances/constants.dart';
import 'package:pocket_finances/screens/home_page.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 150,
          title: Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 20.0, bottom: 20.0),
            child: Text(
              'Minhas Finanças',
              style: kTitleStyle,
            ),
          ),
          elevation: 0,
          bottom: buildTabBar(),
        ),
        body: HomePage(),
      ),
    );
  }
}
