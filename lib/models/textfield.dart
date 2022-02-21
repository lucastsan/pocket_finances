import 'package:flutter/material.dart';

import '../constants.dart';

class ExpTextField extends StatelessWidget {
  const ExpTextField(
      {Key? key,
      required this.controller,
      required this.hintText,
      this.keyboardType,
      this.onTap,
      this.initialValue})
      : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final GestureTapCallback? onTap;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: kActivatedText,
      initialValue: initialValue,
      onTap: onTap,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: kDeactivateText,
        border: OutlineInputBorder(),
      ),
      keyboardType: keyboardType ?? TextInputType.text,
    );
  }
}
