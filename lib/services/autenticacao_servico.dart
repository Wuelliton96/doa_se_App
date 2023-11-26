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
}