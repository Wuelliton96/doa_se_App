import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/cep_model.dart';

class ViaCepApi {
  static Future<AddressInfo?> getAddressInfo(String cep) async {
    final response =
        await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return AddressInfo.fromJson(data);
    } else {
      return null; // Lide com o caso em que a solicitação à API falha
    }
  }
}
