import 'dart:io';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doa_se_app/componentes/decoration_labeText.dart';
import 'package:doa_se_app/models/inserirAnuncio.dart';
import 'package:doa_se_app/utils/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';

import '../../api/api_cep.dart';
import '../../models/cep_model.dart';
import '../../services/anuncio_service.dart';
import '../../widgets/cust_button.dart';
import '../../widgets/cust_valid.dart';
import '../authenticationWrapper.dart';

class InserirAnuncio extends StatefulWidget {
  const InserirAnuncio({super.key});

  @override
  State<InserirAnuncio> createState() => _InserirAnuncioState();
}

class _InserirAnuncioState extends State<InserirAnuncio> {
  final _formKey = GlobalKey<FormState>();
  final AnuncioService anuncioService = AnuncioService();
  late Anuncio _anuncio;
  late BuildContext _dialogcontext;
  List<DropdownMenuItem<String>>? _listaItensDropCategorias = [];
  final List<File> _listaImagens = [];
  String? _itemSelecionadoCategoria;

  //Regras de validação
  final dropdownRequiredValidator =
      CustomDropdownMenuRequiredValidator(errorText: "Campo obrigatório");
  final requiredValidator = RequiredValidator(errorText: "Campo obrigatório");
  final descricaoValidator = MultiValidator([
    RequiredValidator(errorText: "Campo obrigatório"),
    MaxLengthValidator(150, errorText: "Máximo de 150 caracteres"),
  ]);

  String? selectedEstado;
  String? selectedCidade;
  String? selectedBairro;
  AddressInfo? addressInfo;
  String? cep; // Mantém o CEP inserido

  bool isEstadoEnabled =
      true; // Inicialmente, o campo de estado está habilitado
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
                  MaterialPageRoute(builder: (context) => AuthenticationWrapper()),
                  (Route<dynamic> router) => false);
            },
          )
        ],
      ),
    );
  }

  _selecionarImagemGaleria() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagemSelecionada =
        await picker.pickImage(source: ImageSource.gallery);

    if (imagemSelecionada != null) {
      setState(() {
        _listaImagens.add(File(imagemSelecionada.path));
      });
    }
  }

  _carregarItensDropdown() {
    _listaItensDropCategorias = Configuracoes.getCategorias();
  }

  Future _uploadImagens() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();

    for (var imagem in _listaImagens) {
      String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
      Reference arquivo = pastaRaiz
          .child("meus_anuncios")
          .child(_anuncio.id)
          .child(nomeImagem);

      UploadTask uploadTask = arquivo.putFile(imagem);

      await uploadTask.then((TaskSnapshot taskSnapshot) async {
        String url = await taskSnapshot.ref.getDownloadURL();
        _anuncio.fotos.add(url);
      });
    }
  }

  _salvarAnuncio() async {
    _abrirDialog(_dialogcontext);
    await _uploadImagens();
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = auth.currentUser;

    FirebaseFirestore db = FirebaseFirestore.instance;
    await db
        .collection("meus_anuncios")
        .doc(usuarioLogado?.uid)
        .collection("anuncios")
        .doc(_anuncio.id)
        .set(_anuncio.toMap())
        .then((_) async {
      await db
          .collection("anuncios")
          .doc(_anuncio.id)
          .set(_anuncio.toMap())
          .then((_) {
        _showSuccessMessage();
      });
    });
  }

  _abrirDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text("Salvando"),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _carregarItensDropdown();
    _anuncio = Anuncio.gerarId();
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
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // área de imagens
                      FormField<List>(
                        builder: (state) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _listaImagens.length + 1,
                                  itemBuilder: (context, indice) {
                                    if (indice == _listaImagens.length) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: GestureDetector(
                                          onTap: () {
                                            _selecionarImagemGaleria();
                                          },
                                          child: CircleAvatar(
                                            backgroundColor:
                                                Colors.grey.shade400,
                                            radius: 50,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.add_a_photo,
                                                  size: 40,
                                                  color: Colors.grey.shade100,
                                                ),
                                                Text(
                                                  "Adicionar",
                                                  style: TextStyle(
                                                    color: Colors.grey.shade100,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    if (_listaImagens.isNotEmpty) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => Dialog(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Image.file(
                                                        _listaImagens[indice]),
                                                    TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          _listaImagens
                                                              .removeAt(indice);
                                                          Navigator.of(context)
                                                              .pop();
                                                        });
                                                      },
                                                      child: const Text(
                                                        "Excluir",
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                          child: CircleAvatar(
                                            radius: 50,
                                            backgroundImage: FileImage(
                                                _listaImagens[indice]),
                                            child: Container(
                                              color: const Color.fromRGBO(
                                                255,
                                                255,
                                                255,
                                                0.3,
                                              ),
                                              alignment: Alignment.center,
                                              child: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return Container();
                                  },
                                ),
                              ),
                              if (state.hasError)
                                Text(
                                  "[${state.errorText}]",
                                  style: const TextStyle(color: Colors.red),
                                )
                            ],
                          );
                        },
                        initialValue: _listaImagens,
                        validator: (imagens) {
                          if (imagens != null && imagens.isEmpty) {
                            return "É necessário selecionar uma imagem";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TextFormField(
                          decoration: getDecorationLabelText("", "Titulo"),
                          validator: requiredValidator,
                          onSaved: (titulo) {
                            titulo != null ? _anuncio.titulo = titulo : null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TextFormField(
                          decoration: getDecorationLabelText(
                              "", "Descrição (até 150 caracteres)"),
                          maxLines: null,
                          validator: descricaoValidator,
                          onSaved: (descricao) {
                            descricao != null
                                ? _anuncio.descricao = descricao
                                : null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          decoration: getDecorationLabelText("", "Telefone"),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            TelefoneInputFormatter()
                          ],
                          validator: requiredValidator,
                          onSaved: (telefone) {
                            telefone != null
                                ? _anuncio.telefone = telefone
                                : null;
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 4,
                                top: 16,
                                bottom: 16,
                              ),
                              child: DropdownButtonFormField(
                                value: _itemSelecionadoCategoria,
                                decoration:
                                    getDecorationLabelText("", "Categoria"),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                items: _listaItensDropCategorias,
                                onChanged: (valor) {
                                  setState(() {
                                    _itemSelecionadoCategoria = valor;
                                  });
                                },
                                onSaved: (categoria) {
                                  categoria != null
                                      ? _anuncio.categoria = categoria
                                      : null;
                                },
                                validator: dropdownRequiredValidator,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          SizedBox(
                            width: 240,
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              decoration: getDecorationLabelText("", "CEP"),
                              onChanged: (value) {
                                setState(() {
                                  cep = value;
                                });
                              },
                              validator: requiredValidator,
                                onSaved: (cep) {
                                  cep != null ? _anuncio.cep = cep : null;
                                },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
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
                        decoration: getDecorationLabelText("", "Estado"),
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
                        validator: requiredValidator,
                        onSaved: (estado) {
                          estado != null ? _anuncio.estado = estado : null;
                        },
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: selectedCidade,
                        decoration: getDecorationLabelText("", "Cidade"),
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
                        validator: requiredValidator,
                        onSaved: (cidade) {
                          cidade != null ? _anuncio.cidade = cidade : null;
                        },
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: selectedBairro,
                        decoration: getDecorationLabelText("", "Bairro"),
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
                        validator: requiredValidator,
                        onSaved: (bairro) {
                          bairro != null ? _anuncio.bairro = bairro : null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      BotaoCustomizado(
                        texto: "Cadastrar anúncio",
                        onPressed: () {
                          if (_formKey.currentState != null &&
                              _formKey.currentState!.validate()) {
                            // salva os campos
                            _formKey.currentState?.save();
                            // configura dialog context
                            _dialogcontext = context;
                            // salva o anúncio
                            _salvarAnuncio();
                          }
                        },
                      ),
                    ]
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
