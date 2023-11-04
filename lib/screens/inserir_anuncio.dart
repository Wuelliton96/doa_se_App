import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Inserir_anuncio extends StatefulWidget {
  const Inserir_anuncio({Key? key});

  @override
  _Inserir_anuncioState createState() => _Inserir_anuncioState();
}

class _Inserir_anuncioState extends State<Inserir_anuncio> {
  String? selectedCategoria;
  String? selectedEstado;
  String? selectedCidade;
  String? selectedBairro;
  File? selectedImage;

    List<String> categorias = [
    'Categoria 1',
    'Categoria 2',
    'Categoria 3',
    'Categoria 4',
  ];

    List<String> estados = [
    'estado 1',
    'estado 2',
    'estado 3',
    'estado 4',
  ];

    List<String> cidades = [
    'cidade 1',
    'cidade 2',
    'cidade 3',
    'cidade 4',
  ];

    List<String> bairros = [
    'bairro 1',
    'bairro 2',
    'bairro 3',
    'bairro 4',
  ];

  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: Colors.black38,
        fontWeight: FontWeight.w400,
        fontSize: 20,
      ),
      border: OutlineInputBorder(),
      hintText: 'Digite a $labelText',
    );
  }

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File selectedImage = File(pickedFile.path);
      setState(() {
        this.selectedImage = selectedImage;
      });
      
    }
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inserir Anúncio'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.only(
          top: 30,
          left: 30,
          right: 30,
        ),
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Título Anúncio',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                maxLines: 5,
                decoration: _buildInputDecoration("Descrição"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: DropdownButtonFormField<String>(
                value: selectedCategoria,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategoria = newValue;
                  });
                },
                items: categorias.map((String categoria) {
                  return DropdownMenuItem<String>(
                    value: categoria,
                    child: Text(categoria),
                  );
                }).toList(),
                decoration: _buildInputDecoration("Categoria"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: DropdownButtonFormField<String>(
                value: selectedEstado,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedEstado = newValue;
                  });
                },
                items: estados.map((String estado) {
                  return DropdownMenuItem<String>(
                    value: estado,
                    child: Text(estado),
                  );
                }).toList(),
                decoration: _buildInputDecoration("Estado"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: DropdownButtonFormField<String>(
                value: selectedCidade,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCidade = newValue;
                  });
                },
                items: cidades.map((String cidade) {
                  return DropdownMenuItem<String>(
                    value: cidade,
                    child: Text(cidade),
                  );
                }).toList(),
                decoration: _buildInputDecoration("Cidade"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: DropdownButtonFormField<String>(
                value: selectedBairro,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedBairro = newValue;
                  });
                },
                items: bairros.map((String bairro) {
                  return DropdownMenuItem<String>(
                    value: bairro,
                    child: Text(bairro),
                  );
                }).toList(),
                decoration: _buildInputDecoration("Bairro"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: InkWell(
                onTap: () {
                  _pickImage(); // Chama a função para selecionar a imagem
                },
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey,
                  child: selectedImage != null
                      ? Image.file(selectedImage!)
                      : Icon(Icons.camera_alt, size: 50, color: Colors.white), // Ícone da câmera
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 60,
              alignment: Alignment.bottomLeft,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomLeft,
                    stops: [0.3, 1],
                    colors: [
                      Color.fromRGBO(249, 43, 127, 1),
                      Color.fromRGBO(249, 43, 127, 1),
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: SizedBox.expand(
                child: TextButton(
                  child: const Text("Cadastrar",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20)),
                  onPressed: () async {
                    // Coloque a lógica para processar o formulário aqui
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
