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

  // função para enviar imagem selecionada para o Storage do Firebase
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
                          if (value == null) {
                            return "O nome não pode ser vazio"; // não funciona, mas não pode apagar
                          }
                          if (value.isEmpty) {
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
                          if (value == null) {
                            return "O nome não pode ser vazio"; // não funciona, mas não pode apagar
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
                          if (value == null) {
                            return "O e-mail não pode ser vazio"; // não funciona, mas não pode apagar
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
                          if (value == null) {
                            return "A senha não pode ser vazio"; // não funciona, mas não pode apagar
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
                          if (value == null) {
                            return "A senha não pode ser vazio"; // não funciona, mas não pode apagar
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

  void botaoCadastrarClicado() {
    String nomeCompleto = _nomeCompletoController.text;
    String nomeUsuario = _nomeUsuarioController.text;
    String email = _emailController.text;
    String senha = _senhaController.text;
    String confirmarSenha = _confirmarSenhaController.text;

    if (_formKey.currentState!.validate()) {
      print("Formulário validado com sucesso!");
      print(
          "$_nomeCompletoController, $_nomeUsuarioController, $_emailController, $_senhaController, $_confirmarSenhaController");
      if (senha == confirmarSenha) {
        _autenticacaoServico.verificarEmail(email).then((bool? erro) {
          if (erro == true) {
            mostrarMensagem(
                context: context, texto: "Esse e-mail já está em uso!");
          } else {
            _autenticacaoServico
                .cadastrarUsuario(email: email, senha: senha)
                .then((String? erro) {
              if (erro != null) {
                mostrarMensagem(
                    context: context, texto: "Esse e-mail já está em uso!");
              } else {
                _autenticacaoServico
                    .salvarDados(
                        email: email,
                        nomeCompleto: nomeCompleto,
                        nomeUsuario: nomeUsuario,
                        senha: senha)
                    .then((String? erro) {
                  if (erro != null) {
                    mostrarMensagem(
                        context: context, texto: "Cadastro inválido!");
                  }
                });
                //_autenticacaoServico.enviarLinkParaEmail(email);
                fazerUploadImagem();
                _showSuccessMessage(_emailController.text);
              }
            });
          }
        });
      } else {
        mostrarMensagem(context: context, texto: "A senha está diferente!");
      }
    } else {
      mostrarMensagem(
          context: context, texto: "Selecione uma imagem para perfil!");
    }
  }
}

/*
var emailAuth = 'someemail@domain.com';
FirebaseAuth.instance.sendSignInLinkToEmail(
        email: emailAuth, actionCodeSettings: acs)
    .catchError((onError) => print('Error sending email verification $onError'))
    .then((value) => print('Successfully sent email verification'));
});
*/

// && arquivoSelecionado != null