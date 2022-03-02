import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

class ExpTextField extends StatelessWidget {
  const ExpTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.onTap,
    this.initialValue,
    this.validator,
    this.inputFormatters,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final GestureTapCallback? onTap;
  final String? initialValue;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlignVertical: TextAlignVertical.center,
      inputFormatters: inputFormatters,
      validator: validator,
      style: kInputText,
      initialValue: initialValue,
      onTap: onTap,
      controller: controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        hintTextDirection: TextDirection.ltr,
        alignLabelWithHint: true,
        labelStyle: TextStyle(color: kSelectionColor),
        hintText: hintText,
        hintStyle: kHintText,
        border: OutlineInputBorder(),
      ),
      keyboardType: keyboardType ?? TextInputType.text,
    );
  }
}
