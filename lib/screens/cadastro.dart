import 'dart:io';
import 'package:doa_se_app/componentes/decoration_labeText.dart';
import 'package:doa_se_app/screens/login.dart';
import 'package:doa_se_app/services/autenticacao_servico.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:doa_se_app/componentes/mensagem.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final _formKey = GlobalKey<FormState>();
  final AutenticacaoServico _autenticacaoServico = AutenticacaoServico();

  final TextEditingController _nomeCompletoController = TextEditingController();
  final TextEditingController _nomeUsuarioController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();

  //Metodo para alerta da mensagem de cadastro com sucesso
  void _showSuccessMessage(String email) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cadastro realizado com sucesso!'),
        content: Text(
          'Enviamos um e-mail de verificação para o endereço $email. Por favor, verifique sua caixa de entrada e clique no link para ativar sua conta.',
        ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Login()),
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
        .child('docs_images/img-${DateTime.now().toString()}.jpg');

    final UploadTask uploadTask =
        storageRef.putFile(File(arquivoSelecionado!.path));

    uploadTask.whenComplete(() {
      print('Upload concluído com sucesso.');
    }).catchError((error) {
      print('Erro no upload: $error');
    });
  }

  @override
  void dispose() {
    _nomeCompletoController.dispose();
    _nomeUsuarioController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
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
                      Image.asset("assets/doa-se.png", height: 250, width: 250),
                      const SizedBox(
                        height: 70,
                      ),
                      TextFormField(
                        controller: _nomeCompletoController,
                        keyboardType: TextInputType.text,
                        decoration: getDecorationLabelText('Nome Completo'),
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
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nomeUsuarioController,
                        keyboardType: TextInputType.text,
                        decoration: getDecorationLabelText('Nome Usuário'),
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
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        decoration: getDecorationLabelText("E-mail"),
                        validator: (String? value) {
                          if (value == null) {    // Condicional que não pode ser apagado
                            return "";
                          }
                          if (value.isEmpty) {
                            return "*Campo obrigatório";
                          }
                          if (value.length < 5) {
                            return "O e-mail é muito curto";
                          }
                          if (!value.contains("@")) {
                            return "O e-mail não é válido";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _senhaController,
                        decoration: getDecorationLabelText("Senha"),
                        obscureText: true,
                        validator: (String? value) {
                          if (value == null) {    // Condicional que não pode ser apagado
                            return "";
                          }
                          if (value.isEmpty) {
                            return "*Campo obrigatório";
                          }
                          if (value.length < 5) {
                            return "A senha é muito curta";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _confirmarSenhaController,
                        decoration: getDecorationLabelText("Confirmar Senha"),
                        obscureText: true,
                        validator: (String? value) {
                          if (value == null) {    // Condicional que não pode ser apagado
                            return ""; 
                          }
                          if (value.isEmpty) {
                            return "*Campo obrigatório";
                          }
                          if (value.length < 5) {
                            return "A senha é muito curta";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      InkWell(
                        onTap: () {
                          selecionarArquivo(); // Permite ao usuário selecionar uma imagem
                        },
                        child: Column(
                          children: [
                            const Text(
                              "Inserir Documento",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              width: 100,
                              height: 100,
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
                      const SizedBox(height: 32),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(200, 50),
                          textStyle: const TextStyle(fontSize: 22),
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => botaoCadastrarClicado(),
                        child: const Text("Cadastrar"),
                      ),
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

  // Função que é chamada quando o botão de cadastro é clicado
  void botaoCadastrarClicado() {
    // Obter os valores inseridos nos campos do formulário
    String nomeCompleto = _nomeCompletoController.text;
    String nomeUsuario = _nomeUsuarioController.text;
    String email = _emailController.text;
    String senha = _senhaController.text;
    String confirmarSenha = _confirmarSenhaController.text;

    // Verificar se o formulário foi validado com sucesso
    if (_formKey.currentState!.validate()) {
      print("Formulário validado com sucesso!");
      // Verificar se a senha e a confirmação de senha coincidem
      if (senha == confirmarSenha) {
        // Verificar se o e-mail já está em uso
        _autenticacaoServico.verificarEmail(email).then((bool? erro) {
          if (erro == true) {
            // O e-mail já está em uso, exibir uma mensagem de erro
            mostrarMensagem(
                context: context, texto: "Esse e-mail já está em uso!");
          } else {
            // Cadastrar o usuário no Firebase Authentication
            _autenticacaoServico
                .cadastrarUsuario(email: email, senha: senha)
                .then((String? erro) {
              if (erro != null) {
                // Ocorreu um erro no cadastro, exibir uma mensagem de erro
                mostrarMensagem(
                    context: context, texto: "Esse e-mail já está em uso!");
              } else {
                // Salvar os dados do usuário no Firestore
                _autenticacaoServico
                    .salvarDados(
                        email: email,
                        nomeCompleto: nomeCompleto,
                        nomeUsuario: nomeUsuario,
                        senha: senha)
                    .then((String? erro) {
                  if (erro != null) {
                    // Ocorreu um erro ao salvar os dados, exibir uma mensagem de erro
                    mostrarMensagem(
                        context: context, texto: "Cadastro inválido!");
                  }
                });
                // Enviar um link de verificação para o e-mail do usuário
                _autenticacaoServico.enviarLinkParaEmail(email);
                // Realizar o upload da imagem do perfil
                fazerUploadImagem();
                // Exibir uma mensagem de sucesso
                _showSuccessMessage(_emailController.text);
              }
            });
          }
        });
      } else {
        // A senha e a confirmação de senha não coincidem, exibir uma mensagem de erro
        mostrarMensagem(context: context, texto: "A senha está diferente!");
      }
    } else {
      // O formulário não foi validado com sucesso, exibir uma mensagem de erro
      mostrarMensagem(
          context: context, texto: "Selecione uma imagem para perfil!");
    }
  }
}

// && arquivoSelecionado != null