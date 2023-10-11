import 'dart:convert';
import 'package:app_folha_pagamento/models/Cargos.dart';
import 'package:app_folha_pagamento/models/Holerites.dart';
import 'package:http/http.dart' as http;

class HoleriteService {
  final String baseUrl = 'https://192.168.0.240:7256/api';

  Future<List<Holerites>> obterHolerites(String token) async {
    var url = Uri.parse('$baseUrl/holerites');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List listaEmpresas = json.decode(response.body);
      return listaEmpresas.map((json) => Holerites.fromJson(json)).toList();
    } else {
      throw Exception('Erro, não foi possível carregar o Holerite');
    }
  }

  Future<String?> excluirHolerite(int id, String token) async {
    try {
      var url = Uri.parse('$baseUrl/holerites/$id');
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
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

  Future<Holerites> gerarHolerite({
    required int colaboradorId,
    required int mes,
    required int ano,
    required int horasNormais,
    required bool horasExtrasEnabled,
    int horasExtras = 0,
    required int tipo,
    required String token,
  }) async {
    try {
      var url = Uri.parse('$baseUrl/holerites');
      Map<String, dynamic> data = {
        'colaboradorId': colaboradorId,
        'mes': mes,
        'ano': ano,
        'horasNormais': horasNormais,
        'horasExtras': horasExtrasEnabled ? horasExtras : 0,
        'tipo': tipo,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Adicione o token ao cabeçalho
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return Holerites.fromJson(json.decode(response.body));
      } else {
        throw 'Erro ao gerar holerite. Código de status: ${response.statusCode}';
      }
    } catch (error) {
      throw 'Erro ao gerar holerite: $error';
    }
  }
}
