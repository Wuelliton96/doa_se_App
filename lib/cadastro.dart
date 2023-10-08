import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'main.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nomeusuarioController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordconfirmaController = TextEditingController();

  File? selectedImageDocument;

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File selectedImageDocument = File(pickedFile.path);
      setState(() {
        this.selectedImageDocument = selectedImageDocument;
      });
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    nomeusuarioController.dispose();
    passwordController.dispose();
    passwordconfirmaController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
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
            TextFormField(
              controller: nomeController,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                labelText: "Nome completo",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "E-mail",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              height: 10,
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
              height: 10,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: InkWell(
                onTap: () {
                  _pickImage(); // Chama a função para selecionar a imagem
                },
                child: Column(
                  children: [
                    Text(
                      "Inserir Documento",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10), // Espaçamento entre o texto e o ícone
                    Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey,
                      child: selectedImageDocument != null
                          ? Image.file(selectedImageDocument!)
                          : Icon(Icons.camera_alt,
                              size: 50, color: Colors.white), // Ícone da câmera
                    ),
                  ],
                ),
              ),
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
                  child: const Text("Cadastrar",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20)),
                  onPressed: () async {
                    try {
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .signInWithEmailAndPassword(
                        email: nomeController.text,
                        password: nomeusuarioController.text,
                      );
                      // A autenticação foi bem-sucedida, você pode navegar para a próxima tela.
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => HomePag()));
                    } catch (e) {
                      // Trate os erros de autenticação (por exemplo, senha incorreta, usuário não encontrado).
                      print("Erro: $e");
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
