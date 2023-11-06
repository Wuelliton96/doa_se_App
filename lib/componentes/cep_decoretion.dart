import 'package:flutter/material.dart';

InputDecoration buildInputDecoration(String labelText) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: TextStyle(
      color: Colors.black38,
      fontWeight: FontWeight.w400,
      fontSize: 20,
    ),
    border: const OutlineInputBorder(),
    hintText: 'Digite a $labelText',
  );
}
