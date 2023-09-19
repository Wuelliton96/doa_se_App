import 'package:doa_se_app/perfil.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: HomePag(),
    );
  }
}

class HomePag extends StatefulWidget {
  @override
  _HomePagState createState() => _HomePagState();
}

class _HomePagState extends State<HomePag> {
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
        selectedItemColor: Color.fromARGB(
            255, 0, 0, 0), // Define a cor do ícone e texto selecionados
        unselectedItemColor: const Color.fromARGB(
            255, 122, 38, 38), // Define a cor do ícone e texto não selecionados
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
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
    return Login();
  }
}
