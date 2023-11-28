// Importações necessárias
import 'package:doa_se_app/screens/cadastro/cadastro_anuncio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'anuncios_home.dart';
import 'login.dart';
import 'perfil_usuario.dart';

// Widget responsável por gerenciar a autenticação do usuário
class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance
          .authStateChanges(), // Verifica alterações no estado de autenticação
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Mostra um indicador de carregamento enquanto aguarda
        } else if (snapshot.hasData) {
          return const HomePag(); // Se o usuário estiver autenticado, exibe a HomePag
        } else {
          return const Login(); // Caso contrário, exibe a tela de login
        }
      },
    );
  }
}

// Tela principal após o login, com navegação entre diferentes páginas
class HomePag extends StatefulWidget {
  const HomePag({super.key});

  @override
  _HomePagState createState() => _HomePagState();
}

class _HomePagState extends State<HomePag> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(), // Página inicial
    const AdPage(), // Página para inserção de anúncios
    const UserProfilePage(), // Página do perfil do usuário
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Exibe a página atual com base no índice
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex =
                index; // Atualiza o índice da página ao clicar na barra de navegação inferior
          });
        },
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        selectedItemColor: const Color.fromARGB(255, 155, 0, 0),
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Anunciar',
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

// Página inicial com anúncios
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Anuncios(), // Mostra os anúncios na tela
    );
  }
}

// Página para inserir um novo anúncio
class AdPage extends StatelessWidget {
  const AdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: InserirAnuncio(), // Permite inserir um novo anúncio
    );
  }
}

// Página de perfil do usuário
class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PerfilUsuario(), // Exibe o perfil do usuário
    );
  }
}
