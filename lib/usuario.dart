// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'main.dart';

// class Usuario extends StatefulWidget {
//   const Usuario({Key? key});

//   @override
//   UsuarioState createState() => UsuarioState();
// }

// class UsuarioState extends State<Usuario> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   Future<void> _handleSignOut() async {
//     await _auth.signOut();
//     await _googleSignIn.signOut();
//     // Redirecione para a tela de login ou outra tela apropriada após a saída.
//     Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//             builder: (context) =>
//                 HomePage())); // Substitua TelaDeLogin pela tela desejada
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Usuario'),
//         centerTitle: true,
//       ),
//       body: Container(
//         padding: const EdgeInsets.only(
//           top: 30,
//           left: 30,
//           right: 30,
//         ),
//         color: Colors.white,
//         child: ListView(
//           children: <Widget>[
//             Center(
//               child: SizedBox(
//                 width: 600,
//                 height: 280.0,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   color: Colors.blue,
//                   child: Text(
//                     'Nome do Usuario',
//                     style: TextStyle(fontSize: 32),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 60,
//             ),
//             SizedBox(
//               width: 360.0,
//               child: Card(
//                 child: GestureDetector(
//                   onTap: _handleSignOut,
//                   child: const Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       'Meus anuncios',
//                       style: TextStyle(fontSize: 20),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 60,
//             ),
//             SizedBox(
//               width: 360.0,
//               child: Card(
//                 child: GestureDetector(
//                   onTap: _handleSignOut,
//                   child: const Text(
//                     'Meu perfil',
//                     style: TextStyle(fontSize: 20),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 60,
//             ),
//             SizedBox(
//               width: 360.0,
//               child: Card(
//                 child: GestureDetector(
//                   onTap:
//                       _handleSignOut, // Chame a função de logout quando o card for clicado
//                   child: const Text(
//                     'Sair',
//                     style: TextStyle(fontSize: 20),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 60,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

void main() => runApp(Usuario());

class Usuario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Cards Clicáveis'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomCard('Nome do Usuario', Color(0xFFD9D9D9), 0.9,
                  0.3, true), // Card 1 com 80% da largura
              CustomCard('Meus anúncios', Colors.white, 0.9,
                  0.2), // Card 2 com 60% da largura
              CustomCard('Meu perfil', Colors.white, 0.9,
                  0.2), // Card 3 com 70% da largura
              CustomCard('Sair', Colors.white, 0.9,
                  0.1), // Card 4 com 90% da largura
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
        // Ação a ser executada ao clicar no card
        // Por exemplo, você pode adicionar um Navigator para navegar para uma nova tela
        print('$text foi clicado!');
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
