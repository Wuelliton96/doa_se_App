import 'package:flutter/material.dart';

class Configuracoes {
  static List<DropdownMenuItem<String>>? getCategorias() {
    var categorias = <Map<String, String>>[
      {'categoria': 'Imóvel', 'id': "imovel"},
      {'categoria': 'Automóvel', 'id': "automovel"},
      {'categoria': 'Moda', 'id': "moda"},
      {'categoria': 'Eletrônico', 'id': "eletronico"},
      {'categoria': 'Esportes', 'id': "esportes"}
    ];

    final List<DropdownMenuItem<String>> listaItensDropCategorias = [];

    listaItensDropCategorias.add(
      const DropdownMenuItem(
        value: null,
        child: Text(
          "Categoria",
          style: TextStyle(color: Colors.red, fontSize: 18),
        ),
      ),
    );

    listaItensDropCategorias.addAll(categorias.map((value) {
      return DropdownMenuItem<String>(
          value: value['id'], child: Text(value['categoria']!));
    }).toList());

    return listaItensDropCategorias;
  }
}
