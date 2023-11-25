import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsuarioModel {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Método para pegar id do usuário logado
  void obterUsuarioLogado() {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      String idUser = user.uid;
      print('ID do usuário logado: $idUser');
    } else {
      print('Nenhum usuário logado.');
    }
  }

  // Método para cadastrar um novo usuário com email e senha
  Future<String?> cadastrarUsuario({
    required String email,
    required String senha
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
      return null;
      // await userCredential.user!.updateDisplayName(email);
    } on FirebaseAuthException catch (e) {
      if (e.code == "Email já está em uso") {
        return "O usuário já está cadastrado!";
      } else {
        return 'Ocorreu um erro inesperado';
      }
    }
  }

  // Método para salvar os dados do usuário no Cloud Firestore
  Future<String?> salvarDados({
    required String email,
    required String contato,
    required String nomeCompleto,
    required String nomeUsuario,
    required String senha
  }) async {
    try {
      User? user = _firebaseAuth.currentUser;
      DateTime dataHoraAtual = DateTime.now();
      if (user != null) {
        String idUser = user.uid;
        await db
          .collection("usuarios")
          .doc(idUser)
          .set({
            "email": email,
            "contato": contato,
            "nome_completo": nomeCompleto,
            "nome_usuario": nomeUsuario,
            "senha": senha,
            "dataHora": dataHoraAtual.toUtc(),
        });
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Método para enviar link de validação para o e-mail do usuário
  Future<void> enviarLinkParaEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: ActionCodeSettings(
          url: 'https://doase-f8cd1.firebaseapp.com/__/auth/action?mode=action&oobCode=code',
          androidPackageName: 'dev.x_devs.doa_se.doa_se_app',
          handleCodeInApp: true,
          androidInstallApp: true,
          androidMinimumVersion: '16',
        ),
      );
      print('Link de verificação enviado com sucesso para $email. Verifique seu email para concluir o registro.');
    } catch (e) {
      print('Erro ao enviar o link de verificação: $e');
    }
  }
  
  // método para verificar o Nome Completo no Firestone
  Future<bool> verificarNomeCompletoFirestone({
    required String nomeCompleto,
  }) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .where('nome_completo', isEqualTo: nomeCompleto)
        .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Erro ao verificar usuário: $e");
      return false;
    }
  }

  // método para verificar o Nome Usuário no Firestone
  Future<bool> verificarNomeUsuarioFirestone({
    required String nomeUsuario,
  }) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .where('nome_usuario', isEqualTo: nomeUsuario)
        .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Erro ao verificar usuário: $e");
      return false;
    }
  }
  
  // método para verificar o Contato do usuário no Firestone
  Future<bool> verificarEmailFirestone({
    required String email, 
  }) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .where('email', isEqualTo: email)
        .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Erro ao verificar usuário: $e");
      return false;
    }
  }

  // método para verificar o Contato do usuário no Firestone
  Future<bool> verificarContatoFirestone({
    required String contato,
  }) async {
    try { 
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("usuarios")
        .where('contato', isEqualTo: contato)
        .get();
        return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Erro ao verificar usuário: $e");
      return false;
    }
  } 

}