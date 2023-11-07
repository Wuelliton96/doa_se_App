class Usuario {
  String id;
  String nomeCompleto;
  String nomeUsuario;
  String email;
  String senha;

  String? urlImagem;

  Usuario({
    required this.id,
    required this.nomeCompleto,
    required this.nomeUsuario,
    required this.email,
    required this.senha,
  });

  Usuario.fromMap(Map<String, dynamic> map) 
  : id = map["nome"], 
    nomeCompleto = map["nomeCompleto"], 
    nomeUsuario = map["nomeUsuario"], 
    email = map["email"], 
    senha = map["senha"], 
    urlImagem = map["urlImagem"];
  
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nomeCompleto": nomeCompleto,
      "nomeUsuario": nomeUsuario,
      "email": email,
      "senha": senha,
      "urlImagem": urlImagem,
    };
  }
}