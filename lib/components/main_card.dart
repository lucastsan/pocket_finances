import 'package:flutter/material.dart';

class MainCard extends StatelessWidget {
  MainCard({this.cardChild, this.backgroundColor});

  final Widget? cardChild;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: backgroundColor,
      ),
      child: cardChild,
    );
  }
}

class IncomesCard extends StatelessWidget {
  IncomesCard({this.cardChild, this.backgroundColor});

  final Widget? cardChild;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: backgroundColor,
      ),
      child: cardChild,
    );
  }
}
