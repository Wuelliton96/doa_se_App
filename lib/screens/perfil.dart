import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:doa_se_app/screens/login.dart';

class Usuario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text('Perfil'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomCard('Manseira', Color(0xFFD9D9D9), 0.9, 0.3, true),
              CustomCard('Meus anúncios', Colors.white, 0.9, 0.2),
              CustomCard('Meu perfil', Colors.white, 0.9, 0.2),
              CustomCard('Sair', Colors.white, 0.9, 0.1),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String text;
  final double widthFactor;
  final double heightFactor;
  final Color color;
  final bool centertext;

  CustomCard(
      this.text, this.color, this.widthFactor, this.heightFactor, [this.centertext = false]);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (text == 'Meus anúncios') {
          // Adicione a navegação para a página de anúncios
        } else if (text == 'Meu perfil') {
          // Adicione a navegação para a página de perfil
        } else if (text == 'Sair') {
          // Faz o logout usando o Firebase Auth
          FirebaseAuth.instance.signOut().then((_) {
            // Navega de volta para a página de login e remove a pilha de navegação existente
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Login()),
                (Route<dynamic> route) => false);
          }).catchError((error) {
            print('Erro ao fazer logout: $error');
          });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * widthFactor,
        height: MediaQuery.of(context).size.height * heightFactor,
        color: color,
        child: Align(
          alignment: centertext ? Alignment.center : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
