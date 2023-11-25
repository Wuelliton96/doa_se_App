import 'package:doa_se_app/componentes/decoration_labeText.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';

class DadosUsuario extends StatefulWidget {
  const DadosUsuario({Key? key}) : super(key: key);

  @override
  _DadosUsuarioState createState() => _DadosUsuarioState();
}

class _DadosUsuarioState extends State<DadosUsuario> {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nomeUsuarioController = TextEditingController();

  String? _nome;
  String? _email;

  @override
  void initState() {
    super.initState();
    //_buscarDadosUsuario();
  }

  /*Future<void> _buscarDadosUsuario() async {
    try {
      DataSnapshot snapshot =
          await _database.child('usuarios').child('id_do_usuario').once();
      Map<dynamic, dynamic> values = snapshot.value;

      setState(() {
        _nome = values['nome'];
        _email = values['email'];
        _nomeController.text = _nome ?? '';
        _emailController.text = _email ?? '';
      });
    } catch (e) {
      print('Erro ao buscar dados do Firebase: $e');
    }
  }

  Future<void> _salvarDadosUsuario() async {
    try {
      await _database.child('usuarios').child('id_do_usuario').update({
        'nome': _nomeController.text,
        'email': _emailController.text,
      });

      setState(() {
        _nome = _nomeController.text;
        _email = _emailController.text;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Informações atualizadas com sucesso')),
      );
    } catch (e) {
      print('Erro ao salvar dados no Firebase: $e');
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Meu perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/doa-se.png", height: 200, width: 200),
            const SizedBox(
              height: 100,
            ),
            TextFormField(
              controller: _nomeController,
              decoration: getDecorationLabelText('', 'Nome'),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _emailController,
              decoration: getDecorationLabelText('', 'Email'),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _nomeUsuarioController,
              decoration: getDecorationLabelText('', 'Nome usuario'),
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: null,
                  child: Text('Salvar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
