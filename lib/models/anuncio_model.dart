// usuario_model.dart
import 'package:image_picker/image_picker.dart';

class UsuarioModel {
  String titulo;
  String descricao;
  String categoria;
  String cep;
  String estado;
  String cidade;
  String bairro;
  String telefone; // Adicionando o campo telefone
  XFile? imagem;

  UsuarioModel({
    required this.titulo,
    required this.descricao,
    required this.categoria,
    required this.cep,
    required this.estado,
    required this.cidade,
    required this.bairro,
    required this.telefone,
    required this.imagem,
  });

  UsuarioModel.fromMap(Map<String, dynamic> map)
      : titulo = map["titulo"],
        descricao = map["descricao"],
        categoria = map["categoria"],
        cep = map["cep"],
        estado = map["estado"],
        cidade = map["cidade"],
        bairro = map["bairro"],
        telefone = map["telefone"],
        imagem = map["imagem"];

  Map<String, dynamic> toMap() {
    return {
      "titulo": titulo,
      "descricao": descricao,
      "categoria": categoria,
      "cep": cep,
      "estado": estado,
      "cidade": cidade,
      "bairro": bairro,
      "telefone": telefone,
      "imagem": imagem,
    };
  }
}
