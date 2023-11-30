import 'dart:convert';
import 'package:app_folha_pagamento/models/Cargos.dart';
import 'package:app_folha_pagamento/services/config/api_config.dart';
import 'package:app_folha_pagamento/services/usuario_service.dart';
import 'package:http/http.dart' as http;

class CargoService {
  final String baseUrl = ApiConfig.baseUrl;
  final UsuarioService usuarioService = UsuarioService();

  Future<Map<String, dynamic>?> cadastrarCargo(
      String nome, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cargos'),
        body: jsonEncode({'nome': nome}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 201) {
        final cargoJson = json.decode(response.body);
        return cargoJson;
      } else if (response.statusCode == 400) {
        final jsonResponse = json.decode(response.body);
        final errorMessage = jsonResponse['message'];
        throw errorMessage ?? 'Erro ao cadastrar o cargo';
      } else {
        throw 'Erro ao cadastrar o cargo. Código de status: ${response.statusCode}';
      }
    } catch (error) {
      throw 'Erro ao cadastrar o cargo: $error';
    }
  }

  Future<List<Cargos>> obterCargos(String token) async {
    var url = Uri.parse('$baseUrl/cargos');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List listaCargos = json.decode(response.body);
      return listaCargos.map((json) => Cargos.fromJson(json)).toList();
    } else {
      throw Exception('Erro, não foi possível carregar os cargos');
    }
  }

  Future<Cargos> obterCargoPorId(int id, String token) async {
    try {
      var url = Uri.parse('$baseUrl/cargos/$id');
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        return Cargos.fromJson(json.decode(response.body));
      } else {
        throw Exception('Erro, não foi possível carregar o cargo por ID');
      }
    } catch (error) {
      throw 'Erro ao obter o cargo por ID: $error';
    }
  }

  Future<void> editarCargo(int id, String novoNome, String token) async {
    try {
      var url = Uri.parse('$baseUrl/cargos/$id');
      final response = await http.put(
        url,
        body: jsonEncode({'nome': novoNome}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
      } else {
        throw 'Erro ao editar o cargo. Código de status: ${response.statusCode}';
      }
    } catch (error) {
      throw 'Erro ao editar o cargo: $error';
    }
  }

  Future<String?> excluirCargo(int id, String token) async {
    try {
      var url = Uri.parse('$baseUrl/cargos/$id');
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        return 'Cargo Deletado com sucesso';
      } else {
        final responseBody = json.decode(response.body);
        final errorMessage = responseBody['message'] ?? 'Erro desconhecido';
        return errorMessage;
      }
    } catch (error) {
      return 'Erro ao excluir o cargo: $error';
    }
  }
}
