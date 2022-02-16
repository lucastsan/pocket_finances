import 'package:flutter/material.dart';

class SnackBarSelection extends SnackBar {
  SnackBarSelection({required this.selectedItems})
      : super(content: Text(selectedItems.toString() + ' Items selecionados'));

  final int selectedItems;
}
