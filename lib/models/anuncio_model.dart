import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class AnuncioService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> salvarDadosAnuncio({
    required String titulo,
    required String descricao,
    required String? categoria,
    required String cep,
    required String? estado,
    required String? cidade,
    required String? bairro,
    required String telefone, // Adicione o telefone como parâmetro
  }) async {
    try {
      DateTime dataHoraAtual = DateTime.now();
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        String idUser = user.uid;
        String idRandom = const Uuid().v1();
        await db
          .collection("meus_anuncios")
          .doc(idUser)
          .collection("anuncios")
          .doc(idRandom).set({
            "titulo": titulo,
            "descricao": descricao,
            "categoria": categoria,
            "cep": cep,
            "estado": estado,
            "cidade": cidade,
            "bairro": bairro,
            "telefone": telefone,
            "dataHora": dataHoraAtual.toUtc(),
        });
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
