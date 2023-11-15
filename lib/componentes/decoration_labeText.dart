import 'package:flutter/material.dart';

InputDecoration getDecorationLabelText(String label, String labelText) {
  return InputDecoration(
    hintText: label,
    hintStyle: const TextStyle(
      color: Colors.black38,
      fontWeight: FontWeight.w400,
      fontSize: 20,

    ),
    border: const OutlineInputBorder(),
    labelText: labelText,
  );
}