import 'package:flutter/material.dart';

import '../componentes/mensagem.dart';
import '../services/autenticacao_servico.dart';
import 'authenticationWrapper.dart';
import 'cadastro/cadastro_usuario.dart';
import 'redefinir_senha.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final AutenticacaoServico _autenticacaoServico = AutenticacaoServico();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _showPassword = false; // Variável para controlar a visibilidade da senha

  // Estado para controlar a exibição do indicador de carregamento
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acessa conta'),
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
                        controller: _emailController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(labelText: "E-mail"),
                        validator: (String? value) {
                          if (value == null) {
                            // Condicional que não pode ser apagado
                            return "";
                          }
                          if (value.isEmpty) {
                            return "Digite seu e-mail!";
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
                        controller: _senhaController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                            icon: Icon(
                              _showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        obscureText: !_showPassword,
                        validator: (String? value) {
                          if (value == null) {
                            return '';
                          }
                          if (value.isEmpty) {
                            return 'Digite sua senha!';
                          }
                          if (value.length < 5) {
                            return 'A senha é muito curta';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        style: TextButton.styleFrom(
                            textStyle: const TextStyle(
                              fontSize: 15,
                            ),
                            foregroundColor: Colors.black),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RedefinirSenha())),
                        child: const Text("Esqueci minha senha?"),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            textStyle: const TextStyle(
                              fontSize: 15,
                            ),
                            foregroundColor: Colors.black),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Cadastro())),
                        child: const Text("Cadastrar-se?"),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(200, 50),
                          textStyle: const TextStyle(fontSize: 22),
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          // Se estiver carregando, não faz nada
                          if (_isLoading) return;

                          // Chama a função do botão apenas se não estiver carregando
                          botaoEntrarClicado();
                        },
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text("Entrar"),
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

  // Método responsável por limpar o campo do formulário
  void apagarInformacaoFormulario() {
    _emailController.text = '';
    _senhaController.text = '';
  }

  // Método chamado quando o botão "Entrar" é clicado
  botaoEntrarClicado() {
    // Ativa o indicador de carregamento
    setState(() {
      _isLoading = true;
    });
    // Obtém o email e senha do usuário dos controladores de texto
    String email = _emailController.text;
    String senha = _senhaController.text;

    // Verifica se o formulário está validado
    if (_formKey.currentState!.validate()) {
      print("Entrada validada!");
      // Chama o serviço de autenticação para fazer login com o email e senha
      _autenticacaoServico
          .logarUsuario(email: email, senha: senha)
          .then((String? erro) {
        // Verifica se ocorreu algum erro durante o login
        if (erro != null) {
          // Se houver um erro, exibe uma mensagem de erro
          mostrarMensagem(context: context, texto: "Login inválido!");
        } else {
          // Se o login for bem-sucedido, limpa o formulário
          apagarInformacaoFormulario();
          // Navega para a tela "AnuncioHome"
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AuthenticationWrapper(),
            ),
          );
        }
        // Desativa o indicador de carregamento após o processo de login
        setState(() {
          _isLoading = false;
        });
      });
    }
  }
}
