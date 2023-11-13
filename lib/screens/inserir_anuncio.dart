import 'package:doa_se_app/api/api_cep.dart';
import 'package:doa_se_app/componentes/cep_decoretion.dart';
import 'package:doa_se_app/models/cep.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:doa_se_app/services/anuncio_service.dart';

class InserirAnuncio extends StatefulWidget {
  const InserirAnuncio({Key? key});

  @override
  _InserirAnuncioState createState() => _InserirAnuncioState();
}

class _InserirAnuncioState extends State<InserirAnuncio> {
  String? selectedCategoria;
  String? selectedEstado;
  String? selectedCidade;
  String? selectedBairro;
  File? selectedImage;
  AddressInfo? addressInfo;
  String? cep;
  String telefone = '';
  TextEditingController cepController = TextEditingController();
  AnuncioService _anuncioService = AnuncioService();

  Future<void> _fetchAddressFromCEP(String cep) async {
    final info = await ViaCepApi.getAddressInfo(cep);
    if (info != null) {
      setState(() {
        addressInfo = info;
        selectedEstado = info.estado;
        selectedCidade = info.cidade;
        selectedBairro = info.bairro;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao obter informações de endereço')),
      );
    }
  }

  List<String> categorias = [
    'Categoria 1',
    'Categoria 2',
    'Categoria 3',
    'Categoria 4',
  ];

  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(
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
                decoration: const InputDecoration(
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
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: cepController,
                      decoration: _buildInputDecoration("CEP"),
                      keyboardType: const TextInputType.numberWithOptions(),
                      onChanged: (value) {
                        setState(() {
                          cep = value;
                        });
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _fetchAddressFromCEP(cep!);
                    },
                    child: const Text("Buscar"),
                  ),
                ],
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
                items: [addressInfo?.estado ?? ''].map((String estado) {
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
                items: [addressInfo?.cidade ?? ''].map((String cidade) {
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
                items: [addressInfo?.bairro ?? ''].map((String bairro) {
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
              child: TextFormField(
                decoration: _buildInputDecoration("Telefone"),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    telefone = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: InkWell(
                onTap: () {
                  _pickImage();
                },
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey,
                  child: selectedImage != null
                      ? Image.file(selectedImage!)
                      : const Icon(Icons.camera_alt, size: 50, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () async {
                String? resultado = await _anuncioService.salvarDadosAnuncio(
                  titulo: 'Título do Anúncio',
                  descricao: 'Descrição do Anúncio',
                  categoria: selectedCategoria,
                  cep: cep!,
                  estado: selectedEstado,
                  cidade: selectedCidade,
                  bairro: selectedBairro,
                  telefone: telefone,
                );

                if (resultado == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Anúncio inserido com sucesso')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao inserir anúncio: $resultado')),
                  );
                }
              },
              child: const Text("Inserir"),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
