import 'dart:convert';
import 'package:app_folha_pagamento/models/Cargos.dart';
import 'package:app_folha_pagamento/models/Holerites.dart';
import 'package:http/http.dart' as http;

class HoleriteService {
  final String baseUrl = 'https://192.168.0.240:7256/api';

  Future<List<Holerites>> obterHolerites() async {
    var url = Uri.parse('$baseUrl/holerites');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List listaHolerites = json.decode(response.body);
      return listaHolerites.map((json) => Holerites.fromJson(json)).toList();
    } else {
      throw Exception('Erro, não foi possível carregar os cargos');
    }
  }

    Future<String?> excluirHolerite(int id) async {
    try {
      var url = Uri.parse('$baseUrl/holerites/$id');
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Sucesso ao excluir o cargo (status 204 significa "No Content")
        return 'Holerite Deletado com sucesso';
      } else {
        throw 'Erro ao excluir o holerite. Código de status: ${response.statusCode}';
      }
    } catch (error) {
      throw 'Erro ao excluir o holerite: $error';
    }
  }
}
