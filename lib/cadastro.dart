import 'dart:io';
import 'package:doa_se_app/login.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa a biblioteca de autenticação do Firebase
import 'package:firebase_storage/firebase_storage.dart'; // Importa a biblioteca de armazenamento do Firebase
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({Key? key}) : super(key: key);

  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  // Controladores para os campos de entrada de dados
  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nomeusuarioController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordconfirmaController = TextEditingController();

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
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Login()), (Route<dynamic> router) => false);
            },
          )
        ],
      ),
    );
  }

  // Variável para armazenar a imagem selecionada pelo usuário
  File? selectedImageDocument;

  // Função que permite ao usuário selecionar uma imagem da galeria
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

  // Função para registrar um novo usuário
  Future<void> _registerUser() async {
    try {
      // Cria uma conta de usuário no Firebase Auth com o e-mail e a senha fornecidos
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Envia um e-mail de verificação para o usuário
        await user.sendEmailVerification();

        if (selectedImageDocument != null) {
          // Faz upload da imagem de perfil para o Firebase Storage
          Reference storageReference = FirebaseStorage.instance
              .ref()
              .child('docs_images/${user.uid}.jpg');
          await storageReference.putFile(selectedImageDocument!);

          // Obtém a URL da imagem de perfil no Firebase Storage
          //String downloadURL = await storageReference.getDownloadURL();

          // Conecta ao Firestore (um banco de dados) e armazena informações do usuário
          //var FirebaseFirestore;
          //await FirebaseFirestore.instance
          //    .collection('users')
          //    .doc(user.uid)
          //    .set({
          //  'name': nomeController.text,
          //  'email': emailController.text,
          //  'profilePicture': downloadURL,
          //});
        } else {
          // Lidar com o caso em que nenhuma imagem foi selecionada
        }
      } else {
        // Lidar com o caso em que o registro falhou
      }
    } catch (e) {
      // Lidar com erros de registro (por exemplo, e-mail inválido, senha inválida ou e-mail já em uso)
      print("Error: $e");
    }
  }

  // O método dispose é chamado quando a tela é fechada e é usado para limpar recursos
  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    nomeusuarioController.dispose();
    passwordController.dispose();
    passwordconfirmaController.dispose();

    super.dispose();
  }

  // O método build cria a interface do usuário da tela de registro
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.only(
          left: 30,
          right: 30,
        ),
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            SizedBox(
              child: Image.asset("assets/doa-se.png"), // Exibe uma imagem
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
            TextFormField(
              controller: nomeusuarioController,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                labelText: "Nome de usuário",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
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
            TextFormField(
              controller: passwordController,
              keyboardType: TextInputType.text,
              obscureText: true, // Oculta a senha
              decoration: const InputDecoration(
                labelText: "Criar senha",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            TextFormField(
              controller: passwordconfirmaController ,
              keyboardType: TextInputType.text,
              obscureText: true, // Oculta a senha
              decoration: const InputDecoration(
                labelText: "Confirmar senha",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: InkWell(
                onTap: () {
                  _pickImage(); // Permite ao usuário selecionar uma imagem
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
                      child: selectedImageDocument != null
                          ? Image.file(
                              selectedImageDocument!) // Exibe a imagem selecionada
                          : Icon(Icons.camera_alt,
                              size: 50,
                              color: Colors
                                  .white), // Exibe um ícone de câmera se nenhuma imagem for selecionada
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
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
                  onPressed: () {
                    _showSuccessMessage(emailController.text);
                    _registerUser();
                  },
                  // Quando o botão "Cadastrar" é pressionado, chama a função de registro
                  child: const Text("Cadastrar",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20)),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
