import 'package:flutter/material.dart';
import 'package:doa_se_app/componentes/decoration_labeText.dart';
import 'package:doa_se_app/services/autenticacao_servico.dart';


class RedefinirSenha extends StatefulWidget {
  const RedefinirSenha({Key? key}) : super(key: key);

  @override
  State<RedefinirSenha> createState() => _RedefinirSenhaState();
}

class _RedefinirSenhaState extends State<RedefinirSenha> {
  final _formKey = GlobalKey<FormState>();
  final AutenticacaoServico _autenticacaoServico = AutenticacaoServico();

  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController = TextEditingController();

  @override
  void dispose() {
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
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
                      SizedBox(
                        height: 35,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(
                              fontSize: 15, 
                            ),
                            foregroundColor: Colors.black,
                          ),
                          onPressed: null,
                          child: const Text("Cadastre sua nova senha"),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      TextFormField(
                        controller: _senhaController,
                        keyboardType: TextInputType.text,
                        decoration: getDecorationLabelText("", "Senha"),
                        obscureText: true,
                        validator: (String? value) {
                          if (value == null) {
                            // Condicional que não pode ser apagado
                            return "";
                          }
                          if (value.isEmpty) {
                            return "Digite sua senha!";
                          }
                          if (value.length < 5) {
                            return "A senha é muito curta";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _senhaController,
                        keyboardType: TextInputType.text,
                        decoration: getDecorationLabelText("", "Confirmar senha"),
                        obscureText: true,
                        validator: (String? value) {
                          if (value == null) {
                            // Condicional que não pode ser apagado
                            return "";
                          }
                          if (value.isEmpty) {
                            return "Digite sua senha!";
                          }
                          if (value.length < 5) {
                            return "A senha é muito curta";
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
                        onPressed: () => botaoConfirmarClicado(),
                        child: const Text("Confirmar"),
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

  botaoConfirmarClicado() {
    String senha = _senhaController.text;
    String confirmarSenha = _confirmarSenhaController.text;

    if (_formKey.currentState!.validate()) {
      if (senha == confirmarSenha) {

      }
    }
  }
}
