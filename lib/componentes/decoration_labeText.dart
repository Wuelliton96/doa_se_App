import 'package:flutter/material.dart';

InputDecoration getDecorationLabelText(String label) {
  return InputDecoration(
    hintText: label,
    hintStyle: const TextStyle(
      color: Colors.black38,
      fontWeight: FontWeight.w400,
      fontSize: 20,
    ),
  );
}