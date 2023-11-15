import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class AnuncioService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

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
      String id = const Uuid().v1();
      DateTime dataHoraAtual = DateTime.now();

      await db.collection("anuncios").doc(id).set({
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

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
