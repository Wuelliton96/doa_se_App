import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'authenticationWrapper.dart';
import 'dados_usuario.dart';
import 'detalhes_anuncios_usuario.dart';

class PerfilUsuario extends StatefulWidget {
  @override
  _PerfilUsuarioState createState() => _PerfilUsuarioState();
}

class _PerfilUsuarioState extends State<PerfilUsuario> {
  String userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName(); // Carrega o nome do usuário ao iniciar a tela
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserName(); // Atualiza o nome do usuário quando houver mudança nas dependências
  }

  // Carrega o nome do usuário a partir do Firestore
  Future<void> _loadUserName() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          setState(() {
            userName =
                documentSnapshot['nome_usuario'] ?? 'Nome não disponível';
          });
        }
      }).catchError((error) {
        print('Error fetching user data: $error');
      });
    } else {
      setState(() {
        userName = 'Usuário não logado';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text('Perfil'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomCard('$userName', const Color(0xFFD9D9D9), 0.9, 0.3, true),
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
    this.text,
    this.color,
    this.widthFactor,
    this.heightFactor, [
    this.centertext = false,
  ]);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (text == 'Meus anúncios') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AnunciosUsuario()));
        } else if (text == 'Meu perfil') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const DadosUsuario()));
        } else if (text == 'Sair') {
          // Faz o logout usando o Firebase Auth
          FirebaseAuth.instance.signOut().then((_) {
            // Navega de volta para a página de login e remove a pilha de navegação existente
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const AuthenticationWrapper()),
            );
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
              style: const TextStyle(
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
