class AddressInfo {
  final String estado;
  final String cidade;
  final String bairro;

  AddressInfo({
    required this.estado,
    required this.cidade,
    required this.bairro,
  });

  factory AddressInfo.fromJson(Map<String, dynamic> json) {
    return AddressInfo(
      estado: json['uf'],
      cidade: json['localidade'],
      bairro: json['bairro'],
    );
  }

  get states => null;

  get cities => null;
}
