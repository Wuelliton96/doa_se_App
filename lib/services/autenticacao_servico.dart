import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AutenticacaoServico {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  
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

  /* // método para redefinir senha
  Future<void> redefinirSenha(String email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: email,
    );
    // A solicitação de redefinição de senha foi enviada com sucesso.
    // Informe ao usuário que ele deve verificar seu e-mail para redefinir a senha.
    } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      // Usuário com o e-mail fornecido não foi encontrado.
      // Trate o erro ou forneça feedback ao usuário.
    } else {
      // Outro erro ocorreu. Trate de acordo com sua necessidade.
    } 
    }
  } */

}