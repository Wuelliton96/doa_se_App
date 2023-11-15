import 'dart:io';
import 'package:doa_se_app/componentes/decoration_labeText.dart';
import 'package:doa_se_app/screens/login_usuario.dart';
import 'package:doa_se_app/services/autenticacao_servico.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:doa_se_app/componentes/mensagem.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
  final TextEditingController _contatoController = TextEditingController();
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
                      Image.asset("assets/doa-se.png", height: 200, width: 200),
                      const SizedBox(
                        height: 50,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _nomeCompletoController,
                        decoration: getDecorationLabelText("", "Nome Completo"),
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
                      const SizedBox(height: 16),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _nomeUsuarioController,
                        decoration: getDecorationLabelText("", "Nome Usuário"),
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
                      const SizedBox(height: 16),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _emailController,
                        decoration: getDecorationLabelText("", "E-mail"),
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
                      const SizedBox(height: 16),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        inputFormatters: [MaskTextInputFormatter(
                          mask: '(##) # ####-####',
                          filter: {"#": RegExp(r'[0-9]')},
                        ),],
                        controller: _contatoController,
                        decoration: getDecorationLabelText("", "Contato"),
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
                      const SizedBox(height: 16),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _senhaController,
                        decoration: getDecorationLabelText("", "Senha"),
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
                      const SizedBox(height: 16),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _confirmarSenhaController,
                        decoration: getDecorationLabelText("", "Confirmar Senha"),
                        obscureText: true,
                        validator: (String? value) {
                          if (value == null) {    // Condicional que não pode ser apagado
                            return ""; 
                          }
                          if (value.isEmpty) {
                            return "*Campo obrigatório";
                          }
                          if (value.length < 5) {
                            return "A senha é muito curta!";
                          }
                          if (value.length > 11) {
                            return "A senha é muito grande!";
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

  void botaoCadastrarClicado() {
    // Obtendo os valores dos campos do formulário
    String nomeCompleto = _nomeCompletoController.text;
    String nomeUsuario = _nomeUsuarioController.text;
    String email = _emailController.text;
    String contato = _contatoController.text;
    String senha = _senhaController.text;
    String confirmarSenha = _confirmarSenhaController.text;

    // Validando o formulário e se uma imagem foi selecionada
    if (_formKey.currentState!.validate()) {
      print("Formulário validado com sucesso!");
      // Verificando se a senha e a confirmação de senha são iguais
      if (senha == confirmarSenha) {
        // Verificando se o nome completo já existe no banco de dados
        _autenticacaoServico.verificarNomeCompletoFirestone(nomeCompleto: nomeCompleto)
        .then((bool? erro) {
          if (erro == true) {
            mostrarMensagem(context: context, texto: "Nome completo já exitente!");
          } else {
            // Verificando se o nome de usuário já existe no banco de dados
            _autenticacaoServico.verificarNomeUsuarioFirestone(nomeUsuario: nomeUsuario).then((bool? erro) {
              if (erro == true) {
                mostrarMensagem(context: context, texto: "Nome de usuário já exitente!");
              } else {
                // Verificando se o e-mail já está em uso
                _autenticacaoServico.verificarEmailFirestone(email: email)
                .then((bool? erro) {
                  if (erro == true) {
                    mostrarMensagem(context: context, texto: "Esse e-mail já está em uso!");
                  } else {
                    // Verificando se o número de contato já existe
                    _autenticacaoServico.verificarContatoFirestone(contato: contato).then((bool? erro) {
                      if (erro == true) {
                        mostrarMensagem(context: context, texto: "Número de contato já existente!");
                      } else {
                        // Cadastrando o usuário e salvando os dados
                        _autenticacaoServico.cadastrarUsuario(email: email, senha: senha)
                        .then((String? erro) {
                          if (erro != null) {
                            mostrarMensagem(context: context, texto: "Esse e-mail já está em uso!"); 
                          } else {
                            _autenticacaoServico.salvarDados(
                              email: email,
                              contato: contato,
                              nomeCompleto: nomeCompleto,
                              nomeUsuario: nomeUsuario,
                              senha: senha)
                              .then((String? erro) {
                                if (erro != null) {
                                  mostrarMensagem(context: context, texto: "Cadastro inválido!");
                                }
                            });
                            _autenticacaoServico.enviarLinkParaEmail(email);
                            fazerUploadImagem();
                            _showSuccessMessage(_emailController.text);
                          }
                        });
                      }
                    });
                  }
                });
              }
            });
          }
        });
      } else {
        // A senha e a confirmação de senha não são iguais
        mostrarMensagem(context: context, texto: "A senha está diferente!");
      }
    } else {
      // Uma imagem não foi selecionada
      mostrarMensagem(context: context, texto: "Selecione uma imagem de perfil!");
    }
  }
}



// acrescentar na condicional if o "&& arquivoSelecionado != null".

/*substitua pelo código abaixo:
} else if (_formKey.currentState!.validate() && arquivoSelecionado == null) {
  // O formulário não foi validado com sucesso, exibir uma mensagem de erro
  mostrarMensagem(context: context, texto: "Selecione uma imagem de perfil!");
}
*/
