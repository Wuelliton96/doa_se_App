import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../main.dart';

class RedefinirSenha extends StatefulWidget {
  const RedefinirSenha({super.key});

  @override
  _RedefinirSenhaState createState() => _RedefinirSenhaState();
}

class _RedefinirSenhaState extends State<RedefinirSenha> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordconfirmaController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    passwordconfirmaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Redefinir senha'),
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
            SizedBox(
              child: Image.asset("assets/doa-se.png"),
            ),
            Container(
              height: 40,
              alignment: Alignment.center,
              child: TextButton(
                child: Text(
                  "Cadastre sua nova senha",
                  textAlign: TextAlign.right,
                ),
                onPressed: null,
              ),
            ),
            TextFormField(
              controller: passwordController,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Criar senha",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: passwordconfirmaController,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Confirmar senha",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
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
                  child: const Text("Confirmar",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20)),
                  onPressed: () async {
                    try {
                      // UserCredential userCredential = await FirebaseAuth.instance.signInWithPassword(
                      //   // email: emailController.text,
                      //   password: passwordController.text,
                      // );
                      // // A autenticação foi bem-sucedida, você pode navegar para a próxima tela.
                      // // ignore: use_build_context_synchronously
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePag()));
                    } catch (e) {
                      // // Trate os erros de autenticação (por exemplo, senha incorreta, usuário não encontrado).
                      // print("Erro: $e");
                    }
                  },
                ),
              ),
            ),
            // Container(
            //   height: 40,
            //   alignment: Alignment.center,
            //   child:  TextButton(
            //     child: Text(
            //       "Possuo cadastro",
            //       textAlign: TextAlign.right,
            //     ),
            //     onPressed: null,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
