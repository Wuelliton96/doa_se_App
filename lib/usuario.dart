import 'package:doa_se_app/cadastro.dart';
import 'package:doa_se_app/inserir_anuncio.dart';
import 'package:doa_se_app/main.dart';
import 'package:flutter/material.dart';

void main() => runApp(Usuario());


class Usuario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // appBar: AppBar(
        //   title: Text('Perfil'),
        // ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomCard('Nome do Usuario', Color(0xFFD9D9D9), 0.9, 0.3,
                  true), // Card 1 com 80% da largura
              CustomCard('Meus anúncios', Colors.white, 0.9,
                  0.2), // Card 2 com 60% da largura
              CustomCard('Meu perfil', Colors.white, 0.9,
                  0.2), // Card 3 com 70% da largura
              CustomCard(
                  'Sair', Colors.white, 0.9, 0.1), // Card 4 com 90% da largura
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

  CustomCard(this.text, this.color, this.widthFactor, this.heightFactor,
      [this.centertext = false]);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () { 
        // Navigator.of(context).push(MaterialPageRoute(builder: (_) => UserProfilePage()));
        if (text == 'Meus anúncios') {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Inserir_anuncio()), (Route<dynamic> router) => false);
        } else if (text == 'Meu perfil') {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Cadastro()));

        } else if (text == 'Sair') {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>  HomePage()), (Route<dynamic> router) => false);
        }

        // Ação a ser executada ao clicar no card
        // Por exemplo, você pode adicionar um Navigator para navegar para uma nova tela
        // print('$text foi clicado!');
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