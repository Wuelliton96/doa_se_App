import 'dart:io';
import 'package:doa_se_app/api/api_cep.dart';
import 'package:doa_se_app/componentes/decoration_labeText.dart';
import 'package:doa_se_app/main.dart';
import 'package:doa_se_app/models/cep_model.dart';
import 'package:doa_se_app/models/anuncio_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:doa_se_app/componentes/mensagem.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';


class InserirAnuncio extends StatefulWidget {
  const InserirAnuncio({super.key});

  @override
  State<InserirAnuncio> createState() => _InserirAnuncioState();
}

class _InserirAnuncioState extends State<InserirAnuncio> {
  final _formKey = GlobalKey<FormState>();
  final AnuncioService anuncioService = AnuncioService();

  String? selectedCategoria;
  String? selectedEstado;
  String? selectedCidade;
  String? selectedBairro;
  AddressInfo? addressInfo; // Mantém as informações do endereço obtidas da busca por CEP
  String? cep; // Mantém o CEP inserido
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _tituloAnuncioController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  
  List<String> categorias = [
    'Categoria 1',
    'Categoria 2',
    'Categoria 3',
    'Categoria 4',
  ];

  // Método para buscar informações de endereço a partir do CEP usando a ViaCepApi
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
      // Lide com o caso em que a solicitação à API falhe.
      // Você pode mostrar uma mensagem de erro ou lidar com isso conforme necessário.
    }
  }

  //Metodo para alerta da mensagem de cadastro com sucesso
  void _showSuccessMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Anúncio criado com sucesso!'),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (Route<dynamic> router) => false);
            },
          )
        ],
      ),
    );
  }

  // Variável para armazenar a imagem selecionada pelo usuário
  XFile? arquivoSelecionado;

  // Função que permite ao usuário selecionar uma imagem da galeria
  Future<void> selecionarArquivo() async {
    final imagem = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imagem != null) {
      setState(() {
        arquivoSelecionado = imagem;
      });
    }
  }

  // método responsável por enviar imagem selecionada para o Storage do Firebase
  Future<void> fazerUploadImagem() async {
    if (arquivoSelecionado == null) {
      print('Nenhum arquivo selecionado.');
      return;
    }

    final Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('anuncio_images/img-${DateTime.now().toString()}.jpg');

    final UploadTask uploadTask =
        storageRef.putFile(File(arquivoSelecionado!.path));

    uploadTask.whenComplete(() {
      print('Upload concluído com sucesso.');
    }).catchError((error) {
      print('Erro no upload: $error');
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inserir Anúncio'),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formKey,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20,),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _tituloAnuncioController,
                        decoration: getDecorationLabelText("", "Título Anúncio"),
                        inputFormatters: [LengthLimitingTextInputFormatter(40)],
                        validator: (String? value) {
                          if (value == null) {    // Condicional que não pode ser apagado
                            return "";
                          }
                          if (value.isEmpty) {    // Verifica se o campo está vazio
                            return "*Campo obrigatório";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        controller: _descricaoController,
                        decoration: getDecorationLabelText("","Descrição"),
                        maxLines: 5,
                        maxLength: 250,
                        validator: (String? value) {
                          if (value == null) {    // Condicional que não pode ser apagado
                            return ""; 
                          }
                          if (value.isEmpty) {
                            return "*Campo obrigatório";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
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
                        decoration: getDecorationLabelText("","Categoria"),
                        validator: (String? value) {
                          if (value == null) { 
                            return "*Campo obrigatório";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        inputFormatters: [MaskTextInputFormatter(
                          mask: '(##) # ####-####',
                          filter: {"#": RegExp(r'[0-9]')},
                        ),],
                        controller: _telefoneController,
                        decoration: getDecorationLabelText("", "Telefone"),
                        validator: (String? value) {
                          if (value == null) {    // Condicional que não pode ser apagado
                            return "";
                          }
                          if (value.isEmpty) {
                            return "*Campo obrigatório";
                          }
                          if (value.length < 16) {
                            return "Contato incorreto";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          SizedBox(
                            width: 240,
                            child: TextFormField(
                              keyboardType: const TextInputType.numberWithOptions(),
                              controller: _cepController,
                              decoration: getDecorationLabelText("","CEP"),
                              onChanged: (value) {
                                setState(() {
                                  cep = value;
                                });
                              },
                              validator: (String? value) {
                                if (value == null) {    // Condicional que não pode ser apagado
                                  return "";
                                }
                                if (value.isEmpty) {
                                  return "*Campo obrigatório";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                            onPressed: () {
                              // Quando o botão "Buscar" é pressionado, chame a função para buscar informações
                              _fetchAddressFromCEP(cep!);
                            },
                            child: const Text("Buscar"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: selectedEstado,    
                        decoration: getDecorationLabelText("","Estado"),
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
                        validator: (String? value) {
                          if (value == null) {    // Condicional que não pode ser apagado
                            return "*Campo obrigatório";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: selectedCidade,    
                        decoration: getDecorationLabelText("","Cidade"),
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
                        validator: (String? value) {
                          if (value == null) {    // Condicional que não pode ser apagado
                            return "*Campo obrigatório";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: selectedBairro,    
                        decoration: getDecorationLabelText("","Bairro"),
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
                        validator: (String? value) {
                          if (value == null) {    // Condicional que não pode ser apagado
                            return "*Campo obrigatório";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: InkWell(
                          onTap: () {
                            selecionarArquivo(); // Permite ao usuário selecionar uma imagem
                          },
                          child: Column(
                            children: [
                              const Text(
                                "Inserir Foto",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                width: 150,
                                height: 150,
                                color: Colors.grey,
                                child: arquivoSelecionado != null
                                    ? Image.file(File(arquivoSelecionado!
                                        .path)) // Exibe a imagem selecionada
                                    : const Icon(Icons.camera_alt,
                                        size: 50,
                                        color: Colors
                                            .white), // Exibe um ícone de câmera se nenhuma imagem for selecionada
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(200, 50),
                          textStyle: const TextStyle(fontSize: 22),
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => botaoCriarAnuncioClicado(),
                        child: const Text("Criar Anúncio"),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void botaoCriarAnuncioClicado() {
    String tituloAnuncio = _tituloAnuncioController.text;
    String descricaoAnuncio = _descricaoController.text;
    String telefone = _telefoneController.text;
    String cep = _cepController.text;
    String? categoriaAnuncio = selectedCategoria; 
    String? estadoSelecionado = selectedEstado;
    String? cidadeSelecionado = selectedCidade;
    String? bairroSelecionado = selectedBairro;

    if (_formKey.currentState!.validate()) {
      anuncioService.salvarDadosAnuncio(
        titulo: tituloAnuncio, 
        descricao: descricaoAnuncio, 
        categoria: categoriaAnuncio, 
        telefone: telefone, 
        cep: cep, 
        estado: estadoSelecionado, 
        cidade: cidadeSelecionado, 
        bairro: bairroSelecionado).then((String? erro) {
          if (erro != null) {
            mostrarMensagem(context: context, texto: "Erro ao criar o anúncio.");
          } else {
            fazerUploadImagem();
            _showSuccessMessage();
          }
        });
    }
  }
}




