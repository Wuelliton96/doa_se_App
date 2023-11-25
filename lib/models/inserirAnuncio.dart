// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';

class Anuncio {
  late String id;
  late String categoria;
  late String titulo;
  late String telefone;
  late String estado;
  late String bairro;
  late String cidade;
  late String cep;
  late String descricao;
  late List<String> fotos;

  Anuncio();

  Anuncio.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot.id;
    categoria = documentSnapshot["categoria"];
    titulo = documentSnapshot["titulo"];
    telefone = documentSnapshot["telefone"];
    descricao = documentSnapshot["descricao"];
    estado = documentSnapshot["estado"];
    bairro = documentSnapshot["bairro"];
    cidade = documentSnapshot["cidade"];
    cep = documentSnapshot["cep"];
    fotos = List<String>.from(documentSnapshot["fotos"]);
  }

  Anuncio.gerarId() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference anuncios = db.collection("meus_anuncios");
    id = anuncios.doc().id;
    fotos = [];
  }

  DateTime dataHoraAtual = DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "categoria": categoria,
      "titulo": titulo,
      "telefone": telefone,
      "estado": estado,
      "bairro": bairro,
      "cidade": cidade,
      "cep": cep,
      "descricao": descricao,
      "fotos": fotos,
      "dataHora": dataHoraAtual.toUtc(),
    };
  }
}
