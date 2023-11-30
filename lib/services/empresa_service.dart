import 'dart:convert';
import 'package:app_folha_pagamento/models/Empresas.dart';
import 'package:app_folha_pagamento/services/config/api_config.dart';
import 'package:http/http.dart' as http;

class EmpresaService {
  final String baseUrl = ApiConfig.baseUrl;

  Future<List<Empresas>> obterEmpresas(String token) async {
    var url = Uri.parse('$baseUrl/empresas');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List listaEmpresas = json.decode(response.body);
      return listaEmpresas.map((json) => Empresas.fromJson(json)).toList();
    } else {
      throw Exception('Erro, não foi possível carregar a Empresa');
    }
  }
}
