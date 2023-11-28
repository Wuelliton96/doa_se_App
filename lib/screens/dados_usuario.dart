import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../componentes/decoration_labeText.dart';

class DadosUsuario extends StatefulWidget {
  const DadosUsuario({Key? key}) : super(key: key);

  @override
  _DadosUsuarioState createState() => _DadosUsuarioState();
}

class _DadosUsuarioState extends State<DadosUsuario> {
  // ignore: deprecated_member_use
  late final DatabaseReference _database =
      FirebaseDatabase.instance.reference();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _nomeUsuarioController = TextEditingController();

  String? _nomeUsuario;
  String? _email;
  String? _nome;
  bool _salvandoDados = false;

  @override
  void initState() {
    super.initState();
    _buscarDadosUsuarioLogado();
  }

  Future<void> _buscarDadosUsuarioLogado() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          setState(() {
            _nomeUsuario = documentSnapshot['nome_usuario'] ??
                'Nome do usuario não disponível';
            _email = documentSnapshot['email'] ?? 'Email não disponivel';
            _nome = documentSnapshot['nome_completo'] ?? 'Nome não disponivel';
          });
        }
      }).catchError((error) {
        print('Error fetching user data: $error');
      });
    } else {
      setState(() {
        _nomeUsuario = 'Usuário não logado';
      });
    }
  }

  Future<void> _salvarDadosUsuario() async {
    try {
      setState(() {
        _salvandoDados = true;
      });

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        FirebaseFirestore.instance.collection('usuarios').doc(user.uid).update({
          'nome_usuario': _nomeUsuarioController.text,
          'email': _emailController.text,
          'nome_completo': _nomeController.text,
          'ultima_atualizacao': DateTime.now().toString(),
        });

        print(
            'Informações atualizadas com sucesso em ${DateTime.now()} para o usuario $user');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Informações atualizadas com sucesso')),
        );
      }
    } catch (e) {
      print('Erro ao salvar dados no Firebase: $e');
    } finally {
      setState(() {
        _salvandoDados = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Meu perfil'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/doa-se.png", height: 300, width: 300),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _nomeController,
                decoration:
                    getDecorationLabelText('Digite o nome completo', '$_nome'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.text,
                decoration:
                    getDecorationLabelText('Digite o novo email', '$_email'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nomeUsuarioController,
                decoration: getDecorationLabelText(
                    'Digite o nome do novo usuario', '$_nomeUsuario'),
                obscureText: true,
              ),
              const SizedBox(height: 40),
              Visibility(
                visible: _salvandoDados,
                child: CircularProgressIndicator(),
                replacement: ElevatedButton(
                  onPressed: _salvarDadosUsuario,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: Size(300, 50),
                  ),
                  child: const Text(
                    'Atualizar',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
