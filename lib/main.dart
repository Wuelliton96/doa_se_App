import 'package:flutter/material.dart';

void main() {
  runApp(Doase());
}

class Doase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doa-se',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: OlxHomePage(),
    );
  }
}

class OlxHomePage extends StatefulWidget {
  @override
  _OlxHomePageState createState() => _OlxHomePageState();
}

class _OlxHomePageState extends State<OlxHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    AdPage(),
    MessagesPage(),
    UserProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doa-se'),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Color.fromARGB(
            255, 15, 14, 14), // Define a cor de fundo da barra de navegação
        selectedItemColor: const Color.fromARGB(
            255, 148, 42, 42), // Define a cor do ícone e texto selecionados
        unselectedItemColor: const Color.fromARGB(
            255, 122, 38, 38), // Define a cor do ícone e texto não selecionados
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Anúncios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Mensagens',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Página Inicial'),
    );
  }
}

class AdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Página de Anúncios'),
    );
  }
}

class MessagesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Página de Mensagens'),
    );
  }
}

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Página de Perfil do Usuário'),
    );
  }
}
