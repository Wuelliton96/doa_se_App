import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class AutenticacaoServico {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  

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

  // Método para fazer login de um usuário
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

  // Método para verificar se o email já está cadastrado
  Future<bool> verificarEmail(String email) async {
    try {
      final List<String> signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    
      return signInMethods.isNotEmpty;
    } catch (e) {
      print("Erro ao verificar o email: $e");
      return false;
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
  

  /*
  Future<bool> verificarEmailNoFirestore(String email) async {
  try {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('usuarios') // Substitua 'usuarios' pelo nome da sua coleção
        .where('email', isEqualTo: email) // Substitua 'email' pelo nome do campo de e-mail
        .get();
      return querySnapshot.docs.isNotEmpty; // Verifica se algum documento foi encontrado
    } catch (e) {
      print('Erro ao verificar o e-mail no Firestore: $e');
      return false;
    }
  }
  */

}



  