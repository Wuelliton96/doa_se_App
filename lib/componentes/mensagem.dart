import 'package:flutter/material.dart';

mostrarMensagem({
  required BuildContext context, 
  required String texto, 
  bool isErro = true
  }) {
  SnackBar snackBar = SnackBar(
    content: Text(texto),
    backgroundColor: (isErro) ? Colors.red : Colors.green,
    duration: const Duration(seconds: 2),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}


