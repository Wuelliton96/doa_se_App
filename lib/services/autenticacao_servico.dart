import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class AutenticacaoServico {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  User? usuario;
  bool isLoading = true;
  

  verificarUsuarioLogado() {
    _firebaseAuth.authStateChanges().listen((User? user) { 
      usuario = (user == null) ? null : user;
      isLoading = false;
    });
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
      String id = Uuid().v1();
      await db.collection("usuarios").doc(id).set({
        "email": email,
        "contato": contato,
        "nome_completo": nomeCompleto,
        "nome_usuario": nomeUsuario,
        "senha": senha,
      });
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
            .collection('usuarios')
            .where('contato', isEqualTo: contato)
            .get();
        return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Erro ao verificar usuário: $e");
      return false;
    }
  } 

  Future<Map<String, dynamic>?> getUserData() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } else {
      return null;
    }
  } catch (e) {
    print("Erro ao recuperar os dados do usuário: $e");
    return null;
  }
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