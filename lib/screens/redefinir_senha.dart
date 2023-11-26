import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:doa_se_app/screens/login_usuario.dart';

class RedefinirSenha extends StatefulWidget {
  const RedefinirSenha({Key? key}) : super(key: key);

  @override
  State<RedefinirSenha> createState() => _RedefinirSenhaState();
}

class _RedefinirSenhaState extends State<RedefinirSenha> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      // Envio de e-mail bem-sucedido
      print('E-mail de redefinição de senha enviado para $email');

      // Exibe uma mensagem para o usuário
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'E-mail de redefinição de senha enviado para $email',
          ),
          duration: const Duration(seconds: 3),
        ),
      );

      // Redireciona para a tela de login após enviar o e-mail de redefinição
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );
    } catch (e) {
      // Lidar com erros de envio de e-mail
      print('Erro ao enviar e-mail de redefinição: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Redefinir senha'),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
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
                    height: 20,
                  ),
                  const Text(
                    'Redefinição de Senha',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Digite o seu e-mail no campo abaixo e lhe enviaremos um e-mail para fazer a redefinição de senha.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite seu e-mail!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                      textStyle: const TextStyle(fontSize: 22),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Se o formulário for válido, chama a função para redefinir a senha
                        _resetPassword(_emailController.text.trim());
                      }
                    },
                    child: const Text("Enviar e-mail"),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
