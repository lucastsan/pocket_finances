import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pocket_finances/components/Tab_bar.dart';
import 'package:pocket_finances/constants.dart';
import 'package:pocket_finances/screens/current_expenses.dart';
import 'package:pocket_finances/screens/fixed_expenses.dart';
import 'package:pocket_finances/screens/home_page.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

StreamController<int> expController = StreamController<int>();

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final numState = new ValueNotifier(0);

  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 1));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: kbackgroundColor,
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
        body: ValueListenableBuilder<int>(
            valueListenable: numState,
            builder: (context, child, widget) {
              return TabBarView(
                children: [
                  HomePage(
                    expStream: expController.stream,
                  ),
                  CurrentExpensesPage(),
                  FixedExpensesPage(),
                ],
              );
            }),
      ),
    );
  }
}
