class UsuarioModel {

  String nomeCompleto;
  String nomeUsuario;
  String email;
  String contato;
  String senha;

  UsuarioModel({
    required this.nomeCompleto,
    required this.nomeUsuario,
    required this.email,
    required this.contato,
    required this.senha,
  });

  UsuarioModel.fromMap(Map<String, dynamic> map) 
   :
    nomeCompleto = map["nomeCompleto"], 
    nomeUsuario = map["nomeUsuario"], 
    email = map["email"],
    contato = map["contato"],
    senha = map["senha"];
    
  
  Map<String, dynamic> toMap() {
    return {
      "nomeCompleto": nomeCompleto,
      "nomeUsuario": nomeUsuario,
      "email": email,
      "contato": contato,
      "senha": senha,
    };
  }
}