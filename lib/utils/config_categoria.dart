import 'package:flutter/material.dart';

class Configuracoes {
  static List<DropdownMenuItem<String>>? getCategorias() {
    var categorias = <Map<String, String>>[
      {"categoria": "Roupas", "id": "roupas"},
      {"categoria": "Alimentos", "id": "alimentos"},
      {"categoria": "Artigos de Higiene", "id": "higiene"},
      {"categoria": "Livros", "id": "livros"},
      {"categoria": "Brinquedos", "id": "brinquedos"},
      {"categoria": "Móveis", "id": "moveis"},
      {"categoria": "Material Escolar", "id": "escolar"},
      {"categoria": "Eletrônicos", "id": "eletronicos"}
    ];

    final List<DropdownMenuItem<String>> listaItensDropCategorias = [];

    listaItensDropCategorias.add(
      const DropdownMenuItem(
        value: null,
        child: Text(
          "Categoria",
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
