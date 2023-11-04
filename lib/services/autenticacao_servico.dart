import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class AutenticacaoServico {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final bool cadastrado = false;

  // método para cadastrar email e senha do usuário
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

  // método para enviar os dados do formulário de cadastro para o Cloud Firestone
  Future<String?> salvarDados({
    required String email,
    required String nomeCompleto,
    required String nomeUsuario,
    required String senha

  }) async {
    try {
      String id = Uuid().v1();
      await db.collection("usuarios").doc(id).set({
        "email": email,
        "nome_completo": nomeCompleto,
        "nome_usuario": nomeUsuario,
        "senha": senha,
      });
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // método para verificar cadastro no Firebase
  Future<String?> logarUsuario({
    required String email,
    required String senha
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: senha
      );
      return null; 
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  } 

  // método para deslogar usuário
  Future<void> deslogar() async {
    return _firebaseAuth.signOut();
  }

  Future<bool> verificarEmail(String email) async {
    try {
      final List<String> signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    
      return signInMethods.isNotEmpty;
    } catch (e) {
      print("Erro ao verificar o email: $e");
      return false;
    }
  }
}


/*
  Future<void> enviarLinkParaEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: ActionCodeSettings(
          url: 'https://doase-f8cd1.firebaseapp.com/__/auth/action?mode=action&oobCode=code',
          androidPackageName: 'dev.x_devs.doa_se.doa_se_app',
          handleCodeInApp: true,
          androidInstallApp: true,
          androidMinimumVersion: '19',
        ),
      );
      print('Link de verificação enviado com sucesso para $email. Verifique seu email para concluir o registro.');
    } catch (e) {
      print('Erro ao enviar o link de verificação: $e');
    }
  }
*/